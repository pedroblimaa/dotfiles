# My Linux Setup

This repo is how I set up a fresh Linux install with the apps, shell, and
dotfiles I usually want right away.

## What it sets up

- Bazzite setup
- Fedora setup
- NVIDIA drivers on Fedora
- Dotfiles symlinked into `$HOME`

## Scripts

- `Bazzite/Setup.sh`: setup for Bazzite or another Fedora Atomic style system
- `Fedora/Setup.sh`: setup for regular mutable Fedora systems that use `dnf`
- `Fedora/Nvidia.sh`: optional NVIDIA driver install for regular mutable Fedora
- `dotfiles/install.sh`: symlink shell and git config files into `$HOME`

## Usage

### Bazzite

```bash
bash Bazzite/Setup.sh
bash dotfiles/install.sh
```

### Fedora

```bash
sudo dnf upgrade --refresh
bash Fedora/Nvidia.sh
bash Fedora/Setup.sh
bash dotfiles/install.sh
```

## Notes

- `Bazzite/Setup.sh` is for Bazzite or another Fedora Atomic style system.
- Homebrew should already be installed before running `Bazzite/Setup.sh`.
- Reboot after `bash Bazzite/Setup.sh` before running `bash dotfiles/install.sh`.
- `Fedora/Setup.sh` and `Fedora/Nvidia.sh` are for regular DNF-based Fedora systems.
- `Fedora/Nvidia.sh` recommends `sudo dnf upgrade --refresh` first on a fresh install.
- `Fedora/Nvidia.sh` skips the install if no NVIDIA GPU is detected.
- `bash dotfiles/install.sh` can be rerun later if you only want to relink dotfiles.
