#!/bin/bash
# This script installs the following commands in Ubuntu:
# rg fd fzf bat fastfetch tmux zoxide eza jq perf
# lazydocker lazygit procs mtr ncdu tldr shellcheck

set -e  # Exit on error

# Check if running on Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    echo "Error: This script is designed for Ubuntu/Debian systems with apt-get"
    exit 1
fi

echo "Updating package lists..."
sudo apt-get update

# Install packages available directly from apt
echo "Installing packages from apt..."
apt_packages=(
    ripgrep      # rg - faster grep
    fd-find      # fd - faster find (binary is fdfind on Ubuntu)
    fzf          # fzf - fuzzy finder
    bat          # bat - better cat (binary is batcat on Ubuntu)
    tmux         # tmux - terminal multiplexer
    jq           # jq - JSON processor
    mtr          # mtr - network diagnostic
    ncdu         # ncdu - disk usage analyzer
    tldr         # tldr - simplified man pages
    shellcheck   # shellcheck - shell script linter
    linux-tools-common  # perf
)

for package in "${apt_packages[@]}"; do
    # Skip comments
    [[ "$package" =~ ^# ]] && continue
    
    if dpkg -l | grep -q "^ii  $package "; then
        echo "✓ $package is already installed"
    else
        echo "Installing $package..."
        sudo apt-get install -y "$package" || echo "⚠ Failed to install $package"
    fi
done

# Install fastfetch (not in Ubuntu 24.04 default repos, use PPA)
if ! command -v fastfetch &> /dev/null; then
    echo "Installing fastfetch via PPA..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt-get update
    sudo apt-get install -y fastfetch
else
    echo "✓ fastfetch is already installed"
fi

# Create symlinks for fd and bat if needed
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    echo "Creating symlink: fd -> fdfind"
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
fi

if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    echo "Creating symlink: bat -> batcat"
    sudo ln -sf $(which batcat) /usr/local/bin/bat
fi

# Install zoxide (requires Rust/Cargo or manual installation)
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
    echo "✓ zoxide is already installed"
fi

# Install eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
    echo "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update
    sudo apt-get install -y eza
else
    echo "✓ eza is already installed"
fi

# Install lazydocker
if ! command -v lazydocker &> /dev/null; then
    echo "Installing lazydocker..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
else
    echo "✓ lazydocker is already installed"
fi

# Install lazygit
if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    echo "✓ lazygit is already installed"
fi

# Install procs
if ! command -v procs &> /dev/null; then
    echo "Installing procs..."
    PROCS_VERSION=$(curl -s "https://api.github.com/repos/dalance/procs/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo procs.zip "https://github.com/dalance/procs/releases/latest/download/procs-v${PROCS_VERSION}-x86_64-linux.zip"
    unzip -o procs.zip
    sudo install procs /usr/local/bin
    rm procs procs.zip
else
    echo "✓ procs is already installed"
fi

echo ""
echo "✅ All tools installed successfully!"
echo ""
echo "Note: Some tools were installed to /usr/local/bin"
echo "You may need to add it to your PATH or restart your shell."
