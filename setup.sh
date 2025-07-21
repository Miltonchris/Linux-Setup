#!/bin/bash
set -e  # Exit if any command fails

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing base packages ==="
sudo apt install -y \
    git \
    i3 \
    picom \
    curl \
    wget \
    micro \
    rofi \
    zsh \
    vim \
    htop \
    polybar \
    unzip

echo "=== Installing Oh My Zsh ==="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed."
fi

echo "=== Setting Zsh as default shell ==="
chsh -s $(which zsh)

echo "=== Installing zsh plugins ==="
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "=== Installing Powerlevel10k theme ==="
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Modify ~/.zshrc to use plugins and theme (only if not already set)
if ! grep -q "powerlevel10k/powerlevel10k" ~/.zshrc; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
fi

if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's|^plugins=(|plugins=(zsh-autosuggestions zsh-syntax-highlighting |' ~/.zshrc
fi

echo "✅ Setup complete. Please restart your terminal or run: exec zsh"
