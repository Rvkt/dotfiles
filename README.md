# 🚀 WSL Dev Environment Setup

This document describes how to set up a powerful, modern shell environment inside **WSL** (Windows Subsystem for Linux).
We’ll install and configure the following tools:

- [Zsh](#1-zsh) – modern shell
- [Oh My Zsh](#2-oh-my-zsh) – framework for zsh
- [fd](#3-fd) – fast file finder
- [fzf](#4-fzf) – fuzzy finder
- [ripgrep (rg)](#5-ripgrep-rg) – blazing fast search
- [GitHub CLI (gh)](#6-github-cli-gh) – GitHub integration
- [zoxide](#7-zoxide) – smarter `cd`

---

## 1. Zsh
Zsh is an extended shell with more features than Bash.

**Install:**
```bash
sudo apt update
sudo apt install zsh -y
```

**Make it default:**
```bash
chsh -s $(which zsh)
```

Restart your terminal, and you’ll be in `zsh`.

---

## 2. Oh My Zsh
A framework that makes `zsh` easier to manage with themes and plugins.

**Install:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

After installation, your `~/.zshrc` is managed by Oh My Zsh.

---

## 3. fd
`fd` is a modern alternative to `find` — simpler syntax and much faster.

**Install:**
```bash
sudo apt install fd-find -y
```

Ubuntu installs it as `fdfind`. Add an alias in `~/.zshrc`:
```bash
alias fd=fdfind
```

**Examples:**
```bash
fd main                # find files containing 'main'
fd -e py               # find all Python files
fd --hidden foo        # include hidden files
fd -E node_modules/ .  # exclude paths (ignore .gitignore by default)
```

---

## 4. fzf
`fzf` is a general-purpose **fuzzy finder**. It pairs well with `fd`, `rg`, and `zoxide`.

**Install:**
```bash
sudo apt install fzf -y
```

**Enable key bindings and completion (Debian/Ubuntu packages):**
```bash
# Add to ~/.zshrc
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

*(If installed from GitHub: run `~/.fzf/install` to enable these interactively.)*

**Examples:**
```bash
# Fuzzy pick a file
fzf

# Open a file with vim
vim "$(fzf)"

# Search through command history
history | fzf
```

---

## 5. ripgrep (rg)
`ripgrep` is a fast text search tool that respects your `.gitignore` by default.

**Install:**
```bash
sudo apt install ripgrep -y
```

**Examples:**
```bash
rg "TODO"                     # search recursively for TODO
rg -n "main\(" src/          # show line numbers, search in src/
rg -uu "secret"               # include hidden & ignored files
rg --type py "requests.get"   # only Python files
rg --files | fzf              # list tracked files, pipe to fzf
```

**Handy aliases (optional, add to ~/.zshrc):**
```bash
alias rgi='rg -i'            # case-insensitive
alias rgp='rg -n --pretty'   # pretty output with line numbers
```

---

## 6. GitHub CLI (gh)
The official GitHub command-line interface.

**Install:**
```bash
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share-keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
```

**Login:**
```bash
gh auth login
```

**Examples:**
```bash
gh repo clone owner/repo   # clone repo
gh pr list                 # list pull requests
gh issue status            # view issues
```

---

## 7. zoxide
`zoxide` is a smarter `cd` that learns your directory habits.

**Install latest version:**
```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

Ensure `~/.local/bin` is on your PATH. Add this to `~/.zshrc` *above* the init line:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Initialize (and hijack `cd` for smart jumps):
```bash
eval "$(zoxide init zsh --cmd cd)"
```

**Examples:**
```bash
cd project                # jump to your most-used "project" directory
zi                        # interactive jump (requires fzf)
zoxide query -l           # list learned directories
```

---

## ✅ Quick Validation
Verify everything is installed and on PATH:
```bash
zsh --version
fdfind --version   # or fd --version if you set the alias
fzf --version
rg --version
gh --version
zoxide --version
```

---

## 🔥 Workflow Recipes
- `fd | fzf` → fuzzy-pick a file, then open with your editor
- `rg "pattern" | fzf` → search text then interactively pick matches
- `zi` → jump to directories interactively with zoxide + fzf