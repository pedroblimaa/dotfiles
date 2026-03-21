# My Bazzite Setup

This repo is my quick setup for a fresh Bazzite install.

It installs the tools I usually want right away, sets up my shell, adds a few
fonts, and links my dotfiles.

## What it sets up

- Homebrew packages: `git`, `node`, `zsh`, `direnv`
- `corepack` and `pnpm`
- Git editor as `code --wait`
- `ghostty` and VS Code
- Oh My Zsh + `powerlevel10k`
- MesloLGS and JetBrains Mono Nerd Fonts

## Dotfiles

The [`dotfiles`](/var/home/pedrob/Documents/Dev/Scripts/MyBazziteSetup/dotfiles) folder includes my shell and git config files.

Running the installer creates symlinks in `$HOME` and backs up any existing
files with a timestamped `.bak` suffix.

## Usage

```bash
bash BazziteSetup.sh
bash dotfiles/install.sh
```

## Notes

- This is meant for Bazzite or another Fedora Atomic style system.
- Homebrew should already be installed and available in `PATH`.
- `ghostty` and `code` are installed with `rpm-ostree`, so a reboot may be needed.
- The dotfiles step is separate from the main setup script.
