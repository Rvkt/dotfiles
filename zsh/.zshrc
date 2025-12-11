# ============================================================
# ZSH Configuration (Managed via GNU Stow)
# ============================================================

# --- Oh My Zsh ------------------------------------------------
# Load only if present to avoid noisy errors
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="robbyrussell"
  zstyle ':omz:update' mode auto
  plugins=(git z)          # 'z' plugin from OMZ—no need to source external z.sh
  source "$ZSH/oh-my-zsh.sh"
fi

# --- PATH hygiene --------------------------------------------
# Put user-level bins first
[ -d "$HOME/.local/bin" ]      && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ]             && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.atuin/bin" ]      && export PATH="$HOME/.atuin/bin:$PATH"

# Flutter & custom scripts (only if they exist)
[ -d "$HOME/development/flutter/bin" ] && export PATH="$HOME/development/flutter/bin:$PATH"
[ -d "$HOME/Scripts" ]                 && export PATH="$HOME/Scripts:$PATH"

# --- Homebrew paths (macOS) ----------------------------------
# Prefer Apple Silicon path, fallback to Intel
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- fzf (fuzzy finder) --------------------------------------
# Source fzf completions/keybindings when installed
if command -v fzf >/dev/null 2>&1; then
  # Apple Silicon
  [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
  [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  # Intel mac
  [ -f /usr/local/opt/fzf/shell/completion.zsh ] && source /usr/local/opt/fzf/shell/completion.zsh
  [ -f /usr/local/opt/fzf/shell/key-bindings.zsh ] && source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

# --- z (jump) -------------------------------------------------
# You already load the Oh My Zsh 'z' plugin above.
# Avoid double-loading external z.sh to prevent conflicts.

# --- Atuin (enhanced shell history) --------------------------
# If Atuin installed via custom script, load its env first (optional)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# Initialize Atuin only when available (prevents "command not found")
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# --- Aliases --------------------------------------------------
# Load aliases from external file when present
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

# Handy defaults
alias nv='nvim'


# --- SSH Agent Bootstrap (WSL-Safe) --------------------------
# Ensure ~/.ssh exists with safe perms
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh" 2>/dev/null || true
fi

# Start ssh-agent if it's not already running
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null 2>&1
fi

# Small wait loop so agent socket has a moment to appear (WSL timing)
AGENT_TRIES=0
while [ "$AGENT_TRIES" -lt 10 ] && ! ssh-add -l >/dev/null 2>&1; do
  sleep 0.05
  AGENT_TRIES=$((AGENT_TRIES + 1))
done

# Load WSL-specific SSH key if present and not already loaded.
# We match by public-key fingerprint to avoid false negatives.
if [ -f "$HOME/.ssh/wsl_git" ]; then
  PUB="$HOME/.ssh/wsl_git.pub"
  if [ -f "$PUB" ]; then
    FPR=$(ssh-keygen -lf "$PUB" 2>/dev/null | awk '{print $2}')
    if ! ssh-add -l 2>/dev/null | grep -q "$FPR"; then
      ssh-add "$HOME/.ssh/wsl_git" >/dev/null 2>&1 || true
    fi
  else
    # If public not available, fallback to attempting to add private key
    if ! ssh-add -l 2>/dev/null | grep -q "wsl_git"; then
      ssh-add "$HOME/.ssh/wsl_git" >/dev/null 2>&1 || true
    fi
  fi
fi


# ============================================================
# End of File
# ============================================================