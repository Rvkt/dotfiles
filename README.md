# dotfiles

Personal dotfiles and configuration files.

## Structure

```text
~/dotfiles/
├── git/
│   ├── .gitconfig         # Global git configuration
│   └── .gitignore_global  # Global gitignore rules
├── install.sh             # Symlink installer & backup script
├── README.md              # Documentation
└── .gitignore             # Dotfiles repo gitignore
```

## Symlinks Created

- `~/.gitconfig` -> `~/dotfiles/git/.gitconfig`
- `~/.gitignore_global` -> `~/dotfiles/git/.gitignore_global`
- `~/.config/git/config` -> `~/dotfiles/git/.gitconfig`
- `~/.config/git/ignore` -> `~/dotfiles/git/.gitignore_global`
- `~/.dotfiles` -> `~/dotfiles`

## Installation / Sync

Run the install script to create or update all symlinks:

```bash
cd ~/dotfiles
./install.sh
```
