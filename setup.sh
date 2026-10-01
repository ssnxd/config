#!/usr/bin/env bash
#
# setup.sh - Unified configuration setup script
#
# This script symlinks all configuration files to their proper locations.
#
# Usage:
#   ./setup.sh                      # Default setup (no deps install)
#   ./setup.sh --install-deps       # Also install Homebrew dependencies
#   ./setup.sh --reload-tmux        # Kill and restart tmux server
#   ./setup.sh --setup-agent        # Also link AGENTS.md and merge Claude settings
#   ./setup.sh --help               # Show help
#

set -e

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
INSTALL_DEPS=false
RELOAD_TMUX=false
SETUP_AGENT=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

show_help() {
    cat << EOF
Usage: ./setup.sh [OPTIONS]

Setup configuration files with symlinks.
Automatically reloads running applications (tmux, Ghostty) after setup.

Options:
  --install-deps         Install dependencies via Homebrew (default: skip)
  --reload-tmux          Kill tmux server completely (default: just reload config)
  --setup-agent          Link agents/AGENTS.md, merge agents/claude/settings.json
                         into ~/.claude/settings.json, install missing Claude
                         plugins and the skills in agents/skills.txt (default: skip)
  --help                 Show this help message

Examples:
  ./setup.sh                           # Default setup
  ./setup.sh --install-deps            # Setup and install Homebrew deps
  ./setup.sh --reload-tmux             # Setup and kill tmux server
  ./setup.sh --setup-agent             # Setup and configure coding agents

EOF
    exit 0
}

# Create a symlink, backing up existing files if necessary
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi

    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        rm "$target"
    fi

    ln -s "$source" "$target"
    success "Linked $target -> $source"
}

# -----------------------------------------------------------------------------
# Parse Arguments
# -----------------------------------------------------------------------------

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install-deps)
                INSTALL_DEPS=true
                shift
                ;;
            --reload-tmux)
                RELOAD_TMUX=true
                shift
                ;;
            --setup-agent)
                SETUP_AGENT=true
                shift
                ;;
            --help|-h)
                show_help
                ;;
            *)
                error "Unknown option: $1. Use --help for usage."
                ;;
        esac
    done
}

# -----------------------------------------------------------------------------
# Step 1: Install Dependencies (optional)
# -----------------------------------------------------------------------------

install_dependencies() {
    if [[ "$INSTALL_DEPS" != true ]]; then
        info "Skipping dependency installation (use --install-deps to enable)"
        return
    fi

    info "Installing dependencies via Homebrew..."

    if ! command -v brew &>/dev/null; then
        error "Homebrew is not installed. Please install it first: https://brew.sh"
    fi

    if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
        brew bundle install --file="$SCRIPT_DIR/Brewfile"
        success "Dependencies installed"
    else
        warn "Brewfile not found, skipping dependency installation"
    fi
}

# -----------------------------------------------------------------------------
# Step 2: Create Symlinks
# -----------------------------------------------------------------------------

create_symlinks() {
    info "Creating configuration symlinks..."

    # Neovim
    create_symlink "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

    # Ghostty
    create_symlink "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"

    # Tmux
    create_symlink "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Zsh
    create_symlink "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"

    # pgcli
    create_symlink "$SCRIPT_DIR/pgcli/config" "$HOME/.config/pgcli/config"

    # pspg (pager theme used by pgcli)
    create_symlink "$SCRIPT_DIR/pgcli/pspg_theme_catppuccin" "$HOME/.pspg_theme_catppuccin"
}

# -----------------------------------------------------------------------------
# Step 2b: Coding agents (optional)
# -----------------------------------------------------------------------------

# Merge the repo settings into the live settings file. Claude Code writes to
# this file at runtime, so it is merged instead of symlinked. Keys in the repo
# file win; keys only in the live file (secrets, permissions) are kept.
merge_claude_settings() {
    local source="$SCRIPT_DIR/agents/claude/settings.json"
    local target="$HOME/.claude/settings.json"

    command -v jq &>/dev/null || error "jq is required for --setup-agent (brew install jq)"
    jq empty "$source" 2>/dev/null || error "Invalid JSON in $source"

    if [[ -L "$target" ]]; then
        error "$target is a symlink. Remove it and run again."
    fi

    mkdir -p "$(dirname "$target")"

    if [[ ! -f "$target" ]]; then
        cp "$source" "$target"
        success "Created $target from $source"
        return
    fi

    jq empty "$target" 2>/dev/null || error "Invalid JSON in $target. Fix it and run again."

    local tmp
    tmp="$(mktemp "${target}.XXXXXX")"
    if ! jq -s '.[0] * .[1]' "$target" "$source" > "$tmp"; then
        rm -f "$tmp"
        error "Failed to merge $source into $target"
    fi

    if jq -e --slurpfile a "$target" '. == $a[0]' "$tmp" &>/dev/null; then
        rm -f "$tmp"
        success "$target is up to date"
        return
    fi

    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    cp -p "$target" "$backup"
    mv "$tmp" "$target"
    success "Merged $source into $target (backup: $backup)"
}

# Add missing marketplaces and install missing plugins listed in the repo
# settings (extraKnownMarketplaces, enabledPlugins).
install_claude_plugins() {
    local source="$SCRIPT_DIR/agents/claude/settings.json"

    if ! command -v claude &>/dev/null; then
        warn "claude CLI not found, skipping plugin install"
        return
    fi

    local known name repo
    known="$(claude plugin marketplace list --json | jq -r '.[].name')"
    while IFS=$'\t' read -r name repo; do
        if grep -qx "$name" <<< "$known"; then
            success "Marketplace $name is present"
        else
            info "Adding marketplace $name ($repo)..."
            claude plugin marketplace add "$repo" || warn "Failed to add marketplace $name"
        fi
    done < <(jq -r '.extraKnownMarketplaces // {} | to_entries[] | "\(.key)\t\(.value.source.repo)"' "$source")

    local installed plugin
    installed="$(claude plugin list --json | jq -r '.[].id')"
    while read -r plugin; do
        if grep -qx "$plugin" <<< "$installed"; then
            success "Plugin $plugin is installed"
        else
            info "Installing plugin $plugin..."
            claude plugin install "$plugin" --scope user || warn "Failed to install plugin $plugin"
        fi
    done < <(jq -r '.enabledPlugins // {} | to_entries[] | select(.value) | .key' "$source")
}

skill_installed() {
    [[ -f "$HOME/.claude/skills/$1/SKILL.md" ]]
}

# Install the skills in agents/skills.txt that are missing, grouped by source.
install_agent_skills() {
    local manifest="$SCRIPT_DIR/agents/skills.txt"

    if ! command -v npx &>/dev/null; then
        warn "npx not found, skipping skill install"
        return
    fi

    local src
    for src in $(awk '!/^[[:space:]]*(#|$)/ {print $1}' "$manifest" | sort -u); do
        local missing=() skill
        for skill in $(awk -v s="$src" '$1 == s {print $2}' "$manifest"); do
            skill_installed "$skill" || missing+=("$skill")
        done

        if [[ ${#missing[@]} -eq 0 ]]; then
            success "Skills from $src are installed"
            continue
        fi

        info "Installing ${missing[*]} from $src..."
        npx -y skills add "$src" --global --agent claude-code codex --skill "${missing[@]}" --yes \
            || warn "Failed to install skills from $src"
    done
}

setup_agents() {
    if [[ "$SETUP_AGENT" != true ]]; then
        info "Skipping agent setup (use --setup-agent to enable)"
        return
    fi

    info "Setting up coding agents..."

    create_symlink "$SCRIPT_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
    create_symlink "$SCRIPT_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"

    merge_claude_settings
    install_claude_plugins
    install_agent_skills
}

# -----------------------------------------------------------------------------
# Step 3: Reload Tmux (optional - kills server)
# -----------------------------------------------------------------------------

reload_tmux() {
    if [[ "$RELOAD_TMUX" != true ]]; then
        return
    fi

    info "Killing tmux server..."

    if tmux list-sessions &>/dev/null; then
        tmux kill-server
        success "Tmux server killed. Start a new session with: tmux"
    else
        info "No tmux server running"
    fi
}

# -----------------------------------------------------------------------------
# Step 4: Auto-reload running applications
# -----------------------------------------------------------------------------

auto_reload() {
    info "Auto-reloading configurations..."

    # Reload tmux config if server is running (non-destructive)
    if tmux list-sessions &>/dev/null; then
        tmux source-file ~/.tmux.conf 2>/dev/null && \
            success "Reloaded tmux configuration" || \
            warn "Failed to reload tmux configuration"
    else
        info "Tmux server not running, skipping reload"
    fi

    # Reload Ghostty on macOS by sending the reload hotkey (Cmd+Shift+,)
    if [[ "$(uname)" == "Darwin" ]]; then
        if pgrep -x "ghostty" &>/dev/null; then
            osascript -e '
                tell application "System Events"
                    if exists (process "ghostty") then
                        tell process "ghostty"
                            keystroke "," using {command down, shift down}
                        end tell
                    end if
                end tell
            ' 2>/dev/null && \
                success "Sent reload signal to Ghostty (Cmd+Shift+,)" || \
                warn "Failed to send reload signal to Ghostty"
        else
            info "Ghostty not running, skipping reload"
        fi
    else
        # Linux: Ghostty uses Ctrl+Shift+,
        info "Ghostty auto-reload on Linux requires manual: Ctrl+Shift+,"
    fi
}

# -----------------------------------------------------------------------------
# Step 5: Check Script Accessibility
# -----------------------------------------------------------------------------

check_scripts_path() {
    local scripts_dir="$SCRIPT_DIR/scripts"
    local tws_path=''
    local port_path=''

    if [[ ! -d "$scripts_dir" ]]; then
        warn "Scripts directory not found at $scripts_dir; skipping PATH check"
        return
    fi

    tws_path="$(command -v tws 2>/dev/null || true)"
    port_path="$(command -v port 2>/dev/null || true)"

    if [[ "$tws_path" == "$scripts_dir/tws" && "$port_path" == "$scripts_dir/port" ]]; then
        success "Scripts are available on PATH"
        return
    fi

    warn "Your scripts are not available on PATH."
    warn "Add this line to your shell profile (for example ~/.zshrc or ~/.bashrc):"
    printf 'export PATH="%s:$PATH"\n' "$scripts_dir"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    parse_args "$@"

    echo ""
    echo "=============================================="
    echo "  Configuration Setup"
    echo "=============================================="
    echo ""

    install_dependencies
    echo ""
    create_symlinks
    echo ""
    setup_agents
    echo ""
    reload_tmux
    echo ""
    auto_reload
    echo ""
    check_scripts_path
    echo ""

    success "Setup complete!"
    echo ""
}

main "$@"
