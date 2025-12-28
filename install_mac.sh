#!/bin/bash
# This script installs the following commands in macos:
# rg fd fzf bat fastfetch tmux zoxide eza jq perf
# lazydocker lazygit procs mtr ncdu tldr shellcheck

set -e  # Exit on error

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install it first:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "Updating Homebrew..."
brew update

# List of packages to install
packages=(
    ripgrep      # rg - faster grep
    fd           # fd - faster find
    fzf          # fzf - fuzzy finder
    bat          # bat - better cat
    fastfetch    # fastfetch - system info
    tmux         # tmux - terminal multiplexer
    zoxide       # zoxide - smarter cd
    eza          # eza - modern ls
    jq           # jq - JSON processor
    lazydocker   # lazydocker - Docker TUI
    lazygit      # lazygit - Git TUI
    procs        # procs - modern ps
    mtr          # mtr - network diagnostic
    ncdu         # ncdu - disk usage analyzer
    tldr         # tldr - simplified man pages
    shellcheck   # shellcheck - shell script linter
)

echo "Installing CLI tools..."
for package in "${packages[@]}"; do
    if brew list "$package" &> /dev/null; then
        echo "✓ $package is already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

echo ""
echo "✅ All tools installed successfully!"
