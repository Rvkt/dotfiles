#!/usr/bin/env bash

# ============================================================
# ZSH Aliases Setup Script (GNU Stow)
# ============================================================

set -e  # Exit if any command fails

# --- CONFIGURATION ---
DOTFILES_DIR="$HOME/dotfiles"
ZSH_DIR="$DOTFILES_DIR/zsh"
ALIAS_FILE="$HOME/.zsh_aliases"
BACKUP_DIR="$HOME/.zsh_backup_$(date +%Y%m%d_%H%M%S)"

# --- HELPER FUNCTIONS ---
info()    { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m $1"; }

# --- STEP 1: Ensure GNU Stow is installed ---
if ! command -v stow >/dev/null 2>&1; then
  warn "GNU Stow not found. Installing via Homebrew..."
  brew install stow || { echo "Homebrew not found. Please install Stow manually."; exit 1; }
fi
success "GNU Stow is installed."

# --- STEP 2: Create directory structure ---
mkdir -p "$ZSH_DIR"
info "Created directory: $ZSH_DIR"

# --- STEP 3: Backup existing aliases file if needed ---
if [ -f "$ALIAS_FILE" ] && [ ! -L "$ALIAS_FILE" ]; then
  mkdir -p "$BACKUP_DIR"
  mv "$ALIAS_FILE" "$BACKUP_DIR/"
  info "Backed up existing .zsh_aliases to $BACKUP_DIR"
fi

# --- STEP 4: Create .zsh_aliases file in dotfiles if missing ---
if [ ! -f "$ZSH_DIR/.zsh_aliases" ]; then
  cat > "$ZSH_DIR/.zsh_aliases" <<'EOF'
# ============================================================
# ZSH Aliases (Managed via Stow)
# ============================================================

# --- Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# --- System / General ---
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias clr="clear"
alias reload="source ~/.zshrc"
alias zshconfig="nano ~/.zshrc"
alias update="brew update && brew upgrade && brew cleanup"

# --- Git Shortcuts ---
alias gs="git status"
alias ga="git add ."
alias gb="git branch"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gd="git diff"

# --- Flutter Shortcuts ---
alias fr="flutter run"
alias fb="flutter build"
alias fc="flutter clean"
alias fget="flutter pub get"
alias fup="flutter upgrade"
alias fgen="flutter pub run build_runner build --delete-conflicting-outputs"

# --- Utilities ---
alias serve="python3 -m http.server"
alias ports="lsof -i -P | grep LISTEN"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# --- macOS ---
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -delete"
EOF
  success "Created new aliases file at $ZSH_DIR/.zsh_aliases"
fi

# --- STEP 5: Use Stow to link aliases ---
cd "$DOTFILES_DIR"
info "Stowing ZSH aliases..."
stow --adopt zsh

success "✅ ZSH aliases successfully stowed!"
info "To apply immediately, run: source ~/.zsh_aliases"

