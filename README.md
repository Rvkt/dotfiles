# dotfiles

Personal dotfiles and configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```text
~/dotfiles/
├── bash/
│   ├── .bash_profile               # Login shell profile
│   ├── .bashrc                     # Interactive shell configuration & z init
│   ├── .bash_logout                # Logout cleanup script
│   └── .local/share/z/z.sh         # z - jump around directory navigation
├── git/
│   ├── .gitconfig                  # Global git configuration
│   └── .gitignore_global           # Global gitignore rules
├── starship/
│   └── .config/starship.toml       # Starship prompt configuration
├── install.sh                      # GNU Stow automated installer & backup script
├── README.md                       # Documentation
└── .gitignore                      # Dotfiles repository gitignore
```

## Symlinks Created

### Bash (`bash` package)
- `~/.bashrc` -> `~/dotfiles/bash/.bashrc`
- `~/.bash_profile` -> `~/dotfiles/bash/.bash_profile`
- `~/.bash_logout` -> `~/dotfiles/bash/.bash_logout`
- `~/.local/share/z/z.sh` -> `~/dotfiles/bash/.local/share/z/z.sh`

### Git (`git` package)
- `~/.gitconfig` -> `~/dotfiles/git/.gitconfig`
- `~/.gitignore_global` -> `~/dotfiles/git/.gitignore_global`
- `~/.config/git/config` -> `~/dotfiles/git/.gitconfig` *(compatibility)*
- `~/.config/git/ignore` -> `~/dotfiles/git/.gitignore_global` *(compatibility)*

### Starship (`starship` package)
- `~/.config/starship.toml` -> `~/dotfiles/starship/.config/starship.toml`

### Repository Link
- `~/.dotfiles` -> `~/dotfiles`

## Features

- **GNU Stow Package Layout**: Modular, clean directory structure for configurations.
- **`z` Directory Navigation**: Fast folder jumping by frecency (`z <pattern>`), supporting `zoxide` with fallback to `rupa/z`.
- **Automated Backup & Safe Symlinking**: `install.sh` automatically backs up conflicting non-symlink files before linking.

## Installation / Sync

### Option 1: Automated Script (Recommended)

Run the installer to backup conflicts and stow all packages:

```bash
cd ~/dotfiles
./install.sh
```

### Option 2: Using GNU Stow Directly

```bash
cd ~/dotfiles
stow --no-folding --restow -t ~ bash git starship
```
