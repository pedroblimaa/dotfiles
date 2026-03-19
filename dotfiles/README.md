# Dotfiles

This folder stores the shell and git configuration for this machine.

## Included files

- `.zshrc`
- `.p10k.zsh`
- `.gitconfig`
- `.bashrc`
- `.bash_profile`

## Install

Run:

```bash
./dotfiles/install.sh
```

The installer creates symlinks in `$HOME` and backs up any existing files to
`*.bak.YYYYMMDD-HHMMSS`.
