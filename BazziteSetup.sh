#!/usr/bin/env bash
set -euo pipefail

flatpak_packages=(
    com.visualstudio.code
)

brew_packages=(
    git
    node
    zsh
    direnv
)

install_flatpaks() {
    for pkg in "${flatpak_packages[@]}"; do
        flatpak install -y flathub "$pkg"
    done
}

install_brew_packages() {
    for pkg in "${brew_packages[@]}"; do
        brew install "$pkg"
    done
}

setup_node_tools() {
    npm install -g corepack
    corepack enable
    corepack prepare pnpm@latest --activate
}

setup_git() {
    git config --global core.editor "code --wait"
}

install_ghostty() {
    . /etc/os-release
    sudo mkdir -p /etc/yum.repos.d
    curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" \
    | sudo tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo >/dev/null
    
    sudo rpm-ostree refresh-md
    sudo rpm-ostree install ghostty
}

install_zsh_themes() {
    # RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    
    mkdir -p ~/.local/share/fonts
    
    curl -fLo "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "$HOME/.local/share/fonts/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "$HOME/.local/share/fonts/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -fLo "$HOME/.local/share/fonts/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    
    fc-cache -fv
}

main() {
    # install_flatpaks
    # install_brew_packages
    # setup_node_tools
    # setup_git
    # install_ghostty
    install_zsh_themes
}

main
