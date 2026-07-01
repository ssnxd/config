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
  --help                 Show this help message

Examples:
  ./setup.sh                           # Default setup
  ./setup.sh --install-deps            # Setup and install Homebrew deps
  ./setup.sh --reload-tmux             # Setup and kill tmux server

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

    # pgcli
    create_symlink "$SCRIPT_DIR/pgcli/config" "$HOME/.config/pgcli/config"

    # pspg (pager theme used by pgcli)
    create_symlink "$SCRIPT_DIR/pgcli/pspg_theme_catppuccin" "$HOME/.pspg_theme_catppuccin"
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
