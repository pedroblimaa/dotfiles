# My Bazzite Setup

This repo is my quick setup for a fresh Bazzite install.

It installs the tools I usually want right away, sets up my shell, adds a few
fonts, and keeps dotfiles as a separate step.

## What it sets up

- Homebrew packages: `git`, `node`, `zsh`, `direnv`
- `corepack` and `pnpm`
- Git editor as `code --wait`
- `ghostty` and VS Code
- Oh My Zsh + `powerlevel10k`
- MesloLGS and JetBrains Mono Nerd Fonts

## Dotfiles

The `dotfiles` folder includes my shell and git config files.

The dotfiles installer creates symlinks in `$HOME` and backs up any existing
files with a timestamped `.bak` suffix.

## Usage

```bash
bash BazziteSetup.sh
bash dotfiles/install.sh
```

## Notes

- This is meant for Bazzite or another Fedora Atomic style system.
- Homebrew should already be installed.
- `ghostty` and `code` are installed with `rpm-ostree`, so reboot after `bash BazziteSetup.sh` before running `bash dotfiles/install.sh`.
- `bash dotfiles/install.sh` can also be rerun later if you only want to relink dotfiles.
