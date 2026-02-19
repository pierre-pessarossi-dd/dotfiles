#!/usr/bin/env bash
set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

echo "==> Installing vim..."
sudo apt-get update && sudo apt-get install -y vim fzf

echo "==> Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Installing starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo "==> Installing uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "==> Symlinking dotfiles..."
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" | while read df; do
    link=${df/$DOTFILES_PATH/$HOME}
    mkdir -p "$(dirname "$link")"
    ln -sf "$df" "$link"
done

echo "==> Cloning Datadog repos..."
DATADOG_ROOT="$HOME/dd"
mkdir -p "$DATADOG_ROOT"
[ ! -d "$DATADOG_ROOT/dd-analytics" ] && \
    git clone git@github.com:DataDog/dd-analytics.git "$DATADOG_ROOT/dd-analytics"
[ ! -d "$DATADOG_ROOT/data-science" ] && \
    git clone git@github.com:DataDog/data-science.git "$DATADOG_ROOT/data-science"

echo "==> Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

echo "==> Installing pants..."
curl --proto '=https' --tlsv1.2 -fsSL https://static.pantsbuild.org/setup/get-pants.sh | bash
sudo mkdir -p /opt/homebrew/bin
sudo ln -sf "$HOME/.local/bin/pants" /opt/homebrew/bin/pants

echo "==> Setting up ddpants alias..."
if ! grep -q "ddpants" "$HOME/.zshrc"; then
    echo "alias ddpants='\${DATADOG_ROOT}/dd-analytics/scripts/pants.sh'" >> "$HOME/.zshrc"
fi

echo "==> Dotfiles setup complete!"
