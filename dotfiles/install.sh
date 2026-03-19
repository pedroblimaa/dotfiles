#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
timestamp="$(date +%Y%m%d-%H%M%S)"

files=(
    .zshrc
    .p10k.zsh
    .gitconfig
    .bashrc
    .bash_profile
)

is_correct_symlink() {
    local source_path="$1"
    local target_path="$2"

    [[ -L "$target_path" ]] && [[ "$(readlink -f "$target_path")" == "$source_path" ]]
}

target_exists() {
    local target_path="$1"

    [[ -e "$target_path" ]] || [[ -L "$target_path" ]]
}

for file in "${files[@]}"; do
    source_path="$dotfiles_dir/$file"
    target_path="$HOME/$file"

    if [[ ! -e "$source_path" ]]; then
        continue
    fi

    if is_correct_symlink "$source_path" "$target_path"; then
        echo "Already linked: $target_path"
        continue
    fi

    if target_exists "$target_path"; then
        backup_path="${target_path}.bak.${timestamp}"
        mv "$target_path" "$backup_path"
        echo "Backed up: $target_path -> $backup_path"
    fi

    ln -s "$source_path" "$target_path"
    echo "Linked: $target_path -> $source_path"
done
