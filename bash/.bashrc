# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
if [ -n "$OMARCHY_PATH" ] && [ -f "$OMARCHY_PATH/default/bash/rc" ]; then
    source "$OMARCHY_PATH/default/bash/rc"
fi

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Ensure ~/.local/bin is on PATH
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# ----------------------------------------------------------------------
# z - jump around directory navigation
# (uses zoxide if installed, or falls back to rupa/z)
# ----------------------------------------------------------------------
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
elif [ -f "$HOME/.local/share/z/z.sh" ]; then
    . "$HOME/.local/share/z/z.sh"
elif [ -f "$HOME/.dotfiles/bash/.local/share/z/z.sh" ]; then
    . "$HOME/.dotfiles/bash/.local/share/z/z.sh"
elif [ -f "$HOME/dotfiles/bash/.local/share/z/z.sh" ]; then
    . "$HOME/dotfiles/bash/.local/share/z/z.sh"
fi

# ----------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------
alias clr='clear'
alias dotfiles='z dotfiles'
alias reload='source ~/.bash_profile'

