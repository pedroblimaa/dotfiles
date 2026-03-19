#!/usr/bin/env bash
set -euo pipefail

brew_packages=(
    git
    node
    zsh
    direnv
)



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

setup_zsh() {
    # Setup themes
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    # Set as default shell
    sudo usermod -s "$(command -v zsh)" "$USER"
}

install_fonts() {
    local fonts_dir="$HOME/.local/share/fonts"
    local jb_zip="$fonts_dir/JetBrainsMono.zip"
    local jb_tmp_dir="$fonts_dir/jetbrainsmono_nf_tmp"
    
    mkdir -p "$fonts_dir"
    
    # Instal MesloLGS fonts
    curl -fLo "$fonts_dir/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    
    # Install jetbrain fonts
    curl -fLo "$jb_zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    
    rm -rf "$jb_tmp_dir"
    mkdir -p "$jb_tmp_dir"
    
    unzip -o "$jb_zip" -d "$jb_tmp_dir"
    find "$jb_tmp_dir" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$fonts_dir/" \;
    
    rm -rf "$jb_tmp_dir" "$jb_zip"
    
}

main() {
    install_flatpaks
    install_brew_packages
    setup_node_tools
    setup_git
    install_ghostty
    install_vscode
    setup_zsh
    install_fonts
}

main
