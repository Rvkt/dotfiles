#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} Installing dotfiles symlinks from ${DOTFILES_DIR}..."

link_file() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo -e "  ${GREEN}✓${NC} Already linked: $dest -> $src"
            return
        else
            echo -e "  ${YELLOW}!${NC} Updating symlink: $dest"
            rm "$dest"
        fi
    elif [ -e "$dest" ]; then
        local backup="${dest}.bak.$(date +%s)"
        echo -e "  ${YELLOW}!${NC} Backing up existing $dest to $backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓${NC} Linked: $dest -> $src"
}

# Git configurations
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.config/git/config"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.config/git/ignore"

# Optional symlink for .dotfiles -> ~/dotfiles
if [ "$DOTFILES_DIR" != "$HOME/.dotfiles" ] && [ ! -e "$HOME/.dotfiles" ]; then
    ln -s "$DOTFILES_DIR" "$HOME/.dotfiles"
    echo -e "  ${GREEN}✓${NC} Linked: $HOME/.dotfiles -> $DOTFILES_DIR"
fi

echo -e "\n${GREEN}Dotfiles installation completed successfully!${NC}"
