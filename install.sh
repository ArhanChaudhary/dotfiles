#!/usr/bin/env zsh
set -euxo pipefail

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install homebrew packages
brew bundle --file=~/dotfiles/homebrew/.Brewfile

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Install other things I definitely am forgetting...

for d in */; do stow "$d"; done

echo "Successfully installed dotfiles! Restart your terminal to apply changes."
