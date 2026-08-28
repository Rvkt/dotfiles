#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} Setting up dotfiles from ${DOTFILES_DIR} using GNU Stow..."

# Ensure ~/.local/bin is in PATH for stow
export PATH="$HOME/.local/bin:$PATH"

# Ensure stow is available
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}!${NC} GNU Stow is not found in PATH. Attempting to locate..."
    if [ -x "$HOME/.local/bin/stow" ]; then
        echo -e "  ${GREEN}✓${NC} Found stow in ~/.local/bin"
    else
        echo -e "${RED}Error: GNU Stow is required but not installed.${NC}"
        exit 1
    fi
fi

# Define packages to stow
PACKAGES=("bash" "git" "starship")

# Pre-stow backup: remove obsolete symlinks and backup conflicting regular files
backup_conflicts() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"

    if [ ! -d "$pkg_dir" ]; then
        return
    fi

    find "$pkg_dir" -type f | while read -r src_file; do
        local rel_path="${src_file#$pkg_dir/}"
        local dest_file="$TARGET_DIR/$rel_path"

        if [ -e "$dest_file" ] || [ -L "$dest_file" ]; then
            local real_dest real_src
            real_dest="$(realpath "$dest_file" 2>/dev/null || true)"
            real_src="$(realpath "$src_file" 2>/dev/null || true)"

            # If it already resolves to the exact repo source file, skip
            if [ -n "$real_dest" ] && [ "$real_dest" = "$real_src" ]; then
                continue
            fi

            if [ -L "$dest_file" ]; then
                rm "$dest_file"
            elif [ -e "$dest_file" ]; then
                local backup="${dest_file}.bak.$(date +%s)"
                echo -e "  ${YELLOW}!${NC} Backing up existing non-symlink $dest_file to $backup"
                mv "$dest_file" "$backup"
            fi
        fi
    done
}

# Stow packages
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        echo -e "${BLUE}==>${NC} Stowing package: ${pkg}"
        backup_conflicts "$pkg"
        stow -v --no-folding --restow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" "$pkg"
        echo -e "  ${GREEN}✓${NC} Successfully stowed ${pkg}"
    fi
done

# Supplementary symlinks for XDG config compatibility
link_compat() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            return
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        mv "$dest" "${dest}.bak.$(date +%s)"
    fi
    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓${NC} Linked compatibility path: $dest -> $src"
}

echo -e "${BLUE}==>${NC} Configuring compatibility symlinks..."
link_compat "$DOTFILES_DIR/git/.gitconfig" "$HOME/.config/git/config"
link_compat "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.config/git/ignore"

# Optional ~/.dotfiles -> ~/dotfiles link
if [ "$DOTFILES_DIR" != "$HOME/.dotfiles" ] && [ ! -e "$HOME/.dotfiles" ]; then
    ln -s "$DOTFILES_DIR" "$HOME/.dotfiles"
    echo -e "  ${GREEN}✓${NC} Linked: $HOME/.dotfiles -> $DOTFILES_DIR"
fi

echo -e "\n${GREEN}Dotfiles installation and symlinks completed successfully!${NC}"
