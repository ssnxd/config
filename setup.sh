#!/usr/bin/env bash
#
# setup.sh - Unified configuration setup script
#
# This script symlinks all configuration files to their proper locations
# and configures themes based on the SYSTEM_THEME environment variable.
#
# Usage:
#   ./setup.sh                      # Default setup (dark theme, no deps install)
#   ./setup.sh --theme light        # Use light theme
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
THEME="${SYSTEM_THEME:-dark}"
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

Setup configuration files with symlinks and theme support.
Automatically reloads running applications (tmux, Ghostty) after setup.

Options:
  --theme <light|dark>   Set the theme (default: dark, or SYSTEM_THEME env var)
  --install-deps         Install dependencies via Homebrew (default: skip)
  --reload-tmux          Kill tmux server completely (default: just reload config)
  --help                 Show this help message

Examples:
  ./setup.sh                           # Default setup with dark theme
  ./setup.sh --theme light             # Setup with light theme
  ./setup.sh --install-deps            # Setup and install Homebrew deps
  ./setup.sh --theme dark --reload-tmux  # Setup and kill tmux server
  SYSTEM_THEME=light ./setup.sh        # Use env var for theme

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
            --theme)
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    THEME="$2"
                    shift 2
                else
                    error "--theme requires a value (light or dark)"
                fi
                ;;
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

    # Validate theme value
    if [[ "$THEME" != "light" && "$THEME" != "dark" ]]; then
        error "Invalid theme: $THEME. Must be 'light' or 'dark'."
    fi
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
# Step 2: Setup Theme
# -----------------------------------------------------------------------------

setup_theme() {
    info "Setting up theme: $THEME"

    local ghostty_theme
    local tmux_theme_file

    if [[ "$THEME" == "light" ]]; then
        ghostty_theme="Catppuccin Latte"
        tmux_theme_file="$SCRIPT_DIR/tmux/themes/latte.tmux"
    else
        ghostty_theme="Catppuccin Mocha"
        tmux_theme_file="$SCRIPT_DIR/tmux/themes/mocha.tmux"
    fi

    # Generate Ghostty theme.conf
    mkdir -p "$HOME/.config/ghostty"
    echo "theme = \"$ghostty_theme\"" > "$HOME/.config/ghostty/theme.conf"
    success "Generated ~/.config/ghostty/theme.conf with theme: $ghostty_theme"

    # Symlink tmux theme
    mkdir -p "$HOME/.tmux"
    create_symlink "$tmux_theme_file" "$HOME/.tmux/theme.conf"

    # Export SYSTEM_THEME to shell profile if not already present
    local shell_profile="$HOME/.zshrc"
    if [[ -f "$HOME/.bashrc" && ! -f "$HOME/.zshrc" ]]; then
        shell_profile="$HOME/.bashrc"
    fi

    if ! grep -q "export SYSTEM_THEME=" "$shell_profile" 2>/dev/null; then
        echo "" >> "$shell_profile"
        echo "# System theme for config (set by setup.sh)" >> "$shell_profile"
        echo "export SYSTEM_THEME=\"$THEME\"" >> "$shell_profile"
        success "Added SYSTEM_THEME=$THEME to $shell_profile"
    else
        # Update existing SYSTEM_THEME
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/export SYSTEM_THEME=.*/export SYSTEM_THEME=\"$THEME\"/" "$shell_profile"
        else
            sed -i "s/export SYSTEM_THEME=.*/export SYSTEM_THEME=\"$THEME\"/" "$shell_profile"
        fi
        success "Updated SYSTEM_THEME=$THEME in $shell_profile"
    fi
}

# -----------------------------------------------------------------------------
# Step 3: Create Symlinks
# -----------------------------------------------------------------------------

create_symlinks() {
    info "Creating configuration symlinks..."

    # Neovim
    create_symlink "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

    # Ghostty
    create_symlink "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"

    # Tmux
    create_symlink "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
}

# -----------------------------------------------------------------------------
# Step 4: Reload Tmux (optional - kills server)
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
# Step 5: Auto-reload running applications
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

    # Note about Neovim
    info "Neovim will use new theme on next launch"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    parse_args "$@"

    echo ""
    echo "=============================================="
    echo "  Configuration Setup"
    echo "  Theme: $THEME"
    echo "=============================================="
    echo ""

    install_dependencies
    echo ""
    setup_theme
    echo ""
    create_symlinks
    echo ""
    reload_tmux
    echo ""
    auto_reload
    echo ""

    success "Setup complete!"
    echo ""
    info "To switch themes, run:"
    echo "  ./setup.sh --theme light"
    echo "  ./setup.sh --theme dark"
    echo ""
}

main "$@"
