# My Linux Setup

This repo is how I set up a fresh Linux install with the apps, shell, and
dotfiles I usually want right away.

## What it sets up

- Bazzite setup
- Fedora setup
- NVIDIA drivers on Fedora
- Dotfiles symlinked into `$HOME`

## Scripts

- `Bazzite/Bazzite.sh`: setup for Bazzite or another Fedora Atomic style system
- `Fedora/Fedora.sh`: setup for regular mutable Fedora systems that use `dnf`
- `Fedora/Nvidia.sh`: optional NVIDIA driver install for regular mutable Fedora
- `dotfiles/install.sh`: symlink shell and git config files into `$HOME`

## Usage

### Bazzite

```bash
bash Bazzite/Bazzite.sh
bash dotfiles/install.sh
```

### Fedora

```bash
sudo dnf upgrade --refresh
bash Fedora/Nvidia.sh
bash Fedora/Fedora.sh
bash dotfiles/install.sh
```

## Notes

- `Bazzite/Bazzite.sh` is for Bazzite or another Fedora Atomic style system.
- Homebrew should already be installed before running `Bazzite/Bazzite.sh`.
- Reboot after `bash Bazzite/Bazzite.sh` before running `bash dotfiles/install.sh`.
- `Fedora/Fedora.sh` and `Fedora/Nvidia.sh` are for regular DNF-based Fedora systems.
- `Fedora/Nvidia.sh` recommends `sudo dnf upgrade --refresh` first on a fresh install.
- `Fedora/Nvidia.sh` skips the install if no NVIDIA GPU is detected.
- `bash dotfiles/install.sh` can be rerun later if you only want to relink dotfiles.
