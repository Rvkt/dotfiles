# ============================================================
# ZSH Configuration (Managed via GNU Stow)
# ============================================================

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Extend PATH for Flutter and custom scripts
export PATH="$PATH:$HOME/development/flutter/bin"
export PATH="$PATH:$HOME/Scripts"

# Set Zsh theme
ZSH_THEME="robbyrussell"

# Auto-update Oh My Zsh without asking
zstyle ':omz:update' mode auto

# Plugins
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh


# ============================================================
# Tools & Integrations
# ============================================================

# fzf (fuzzy finder)
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# z (jump to frequently used directories)
if [ -f /opt/homebrew/share/z/z.sh ]; then
    . /opt/homebrew/share/z/z.sh
fi

# Atuin (enhanced shell history)
eval "$(atuin init zsh)"

# Load aliases from external file
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# ============================================================
# End of File
# ============================================================alias nv='nvim'
