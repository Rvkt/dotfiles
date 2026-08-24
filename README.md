# dotfiles

Personal dotfiles and configuration files.

## Structure

```text
~/dotfiles/
├── gitconfig              # Global git configuration
├── git/
│   ├── .gitconfig         # Symlink to ../gitconfig
│   ├── .gitignore_global  # Global gitignore rules
│   └── ignore             # Symlink to .gitignore_global
├── install.sh             # Symlink installer & backup script
├── README.md              # Documentation
└── .gitignore             # Dotfiles repo gitignore
```

## Symlinks Created

- `~/.gitconfig` -> `~/dotfiles/gitconfig`
- `~/.gitignore_global` -> `~/dotfiles/git/.gitignore_global`
- `~/.config/git/config` -> `~/dotfiles/gitconfig`
- `~/.config/git/ignore` -> `~/dotfiles/git/.gitignore_global`
- `~/.dotfiles` -> `~/dotfiles`

## Installation / Sync

Run the install script to create or update all symlinks:

```bash
cd ~/dotfiles
./install.sh
```
