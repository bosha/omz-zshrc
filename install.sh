#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

REPO_URL="git@github.com:bosha/omz-zshrc.git" 
INSTALL_DIR="$HOME/.zsh-bosha"
ZSHRC_SYMLINK="$HOME/.zshrc"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh/custom/plugins"
OH_MY_ZSH_INSTALL_DIR="$HOME/.oh-my-zsh"

# Check if required dependencies are installed
if ! command -v zsh &> /dev/null; then
	echo "Error: zsh is not installed. Please install zsh and re-run the script."
	exit 1
fi

if ! command -v git &> /dev/null; then
	echo "Error: git is not installed. Please install git and re-run the script."
	exit 1
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$OH_MY_ZSH_INSTALL_DIR" ]; then
	echo "Installing Oh My Zsh..."
	RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Oh My Zsh is already installed."
fi

# Clone the repository with my configuration
if [ -d "$INSTALL_DIR" ]; then
	echo "Directory $INSTALL_DIR already exists. Pulling latest changes..."
	git -C "$INSTALL_DIR" pull
else
	echo "Cloning repository into $INSTALL_DIR..."
	git clone "$REPO_URL" "$INSTALL_DIR"
fi
# Install zsh-syntax-highlighting
ZSH_SYNTAX_HIGHLIGHTING_DIR="$OH_MY_ZSH_DIR/zsh-syntax-highlighting"
if [ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
	echo "Updating zsh-syntax-highlighting..."
	git -C "$ZSH_SYNTAX_HIGHLIGHTING_DIR" pull
else
	echo "Cloning zsh-syntax-highlighting into Oh My Zsh plugins directory..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
fi

# Install zsh-autosuggestions
ZSH_AUTOSUGGESTIONS_DIR="$OH_MY_ZSH_DIR/zsh-autosuggestions"
if [ -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
	echo "Updating zsh-autosuggestions..."
	git -C "$ZSH_AUTOSUGGESTIONS_DIR" pull
else
	echo "Cloning zsh-autosuggestions into Oh My Zsh plugins directory..."
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_DIR"
fi

# Create a symlink to ~/.zshrc
if [ -f "$ZSHRC_SYMLINK" ] || [ -L "$ZSHRC_SYMLINK" ]; then
	echo "Backing up existing ~/.zshrc to ~/.zshrc.backup"
	mv "$ZSHRC_SYMLINK" "$HOME/.zshrc.backup"
fi

echo "Creating symlink for .zshrc..."
ln -s "$INSTALL_DIR/zshrc" "$ZSHRC_SYMLINK"

echo "Installation complete! Restart your terminal or run 'exec zsh' to apply changes."
