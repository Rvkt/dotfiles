#!/usr/bin/env bash

#

# check_fix_and_stow_interactive.sh

# Interactively checks, fixes, and stows your dotfiles with GNU Stow.

#

# Usage:

# ./check_fix_and_stow_interactive.sh [dotfiles_dir]

#

# Example:

# ./check_fix_and_stow_interactive.sh ~/dotfiles

set -e

DOTFILES_DIR="${1:-$HOME/dotfiles}"

if [ ! -d "$DOTFILES_DIR" ]; then
echo "❌ Dotfiles directory not found: $DOTFILES_DIR"
exit 1
fi

echo "🔍 Checking, fixing, and stowing dotfiles in: $DOTFILES_DIR"
echo "-------------------------------------------------------------"

found_issue=false
fixed_count=0
stowed_count=0

for pkg in "$DOTFILES_DIR"/*; do
[ -d "$pkg" ] || continue
pkg_name=$(basename "$pkg")

echo ""
echo "📦 Processing package: $pkg_name"
read -p "➡️  Do you want to check and fix '$pkg_name'? [y/N]: " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && { echo "⏩ Skipping $pkg_name"; continue; }

while IFS= read -r -d '' file; do
rel_path="${file#$pkg/}"  # relative to package root
base_name=$(basename "$file")

```
# Auto-fix misplaced files
if [[ ! "$rel_path" =~ ^\. ]]; then
  echo "⚠️  [$pkg_name] File '$rel_path' not Stow-compliant."
  read -p "   ➕ Move it to '.config/$pkg_name/$base_name'? [y/N]: " fix_confirm
  if [[ "$fix_confirm" =~ ^[Yy]$ ]]; then
    target_dir="$pkg/.config/$pkg_name"
    mkdir -p "$target_dir"
    mv "$file" "$target_dir/$base_name"
    echo "✅ Moved to $target_dir/$base_name"
    found_issue=true
    ((fixed_count++))
  else
    echo "⏩ Skipped fixing $rel_path"
  fi
fi

# Ensure the .config path exists in home
rel_path="${file#$pkg/}"
if [[ "$rel_path" =~ ^\.config/ ]]; then
  config_dir="$HOME/$(dirname "$rel_path")"
  if [ ! -d "$config_dir" ]; then
    echo "📁 Missing target path: $config_dir"
    read -p "   ➕ Create it? [y/N]: " create_confirm
    if [[ "$create_confirm" =~ ^[Yy]$ ]]; then
      mkdir -p "$config_dir"
      echo "✅ Created $config_dir"
    else
      echo "⏩ Skipped creating $config_dir"
    fi
  fi
fi
```

done < <(find "$pkg" -type f -print0)

echo ""
read -p "🔗 Run 'stow --adopt $pkg_name'? [y/N]: " stow_confirm
if [[ "$stow_confirm" =~ ^[Yy]$ ]]; then
(cd "$DOTFILES_DIR" && stow --adopt "$pkg_name")
echo "✅ Stowed $pkg_name"
((stowed_count++))
else
echo "⏩ Skipped stowing $pkg_name"
fi
done

echo "-------------------------------------------------------------"
if [ "$found_issue" = false ]; then
echo "✅ All packages were already Stow-compatible."
else
echo "✨ Fixed $fixed_count issue(s)."
fi

echo "🔗 Successfully stowed $stowed_count package(s)."
echo "🏁 Done!"