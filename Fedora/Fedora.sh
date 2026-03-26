#!/usr/bin/env bash
set -euo pipefail

dnf_packages=(
    git
    nodejs
    npm
    zsh
    direnv
    curl
    unzip
    fontconfig
    dnf-plugins-core
    gnome-tweaks
    gnome-extensions-app
    gnome-shell-extension-user-theme
    gnome-themes-extra
    gtk-murrine-engine
    papirus-icon-theme
    sassc
)

install_dnf_packages() {
    sudo dnf install -y "${dnf_packages[@]}"
}

install_google_chrome() {
    sudo tee /etc/yum.repos.d/google-chrome.repo >/dev/null <<'EOF'
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

    sudo dnf install -y google-chrome-stable
}

install_orchis_theme() {
    local themes_src_dir="$HOME/.local/src"
    local orchis_dir="$themes_src_dir/Orchis-theme"

    mkdir -p "$themes_src_dir"

    if [[ ! -d "$orchis_dir/.git" ]]; then
        git clone https://github.com/vinceliuice/Orchis-theme.git "$orchis_dir"
    else
        git -C "$orchis_dir" pull --ff-only
    fi

    (
        cd "$orchis_dir"
        ./install.sh -i fedora
    )
}

install_bibata_cursor() {
    sudo dnf copr enable -y peterwu/rendezvous
    sudo dnf install -y bibata-cursor-themes
}

setup_node_tools() {
    # Some Fedora Node builds may not expose corepack by default.
    if ! command -v corepack >/dev/null 2>&1; then
        sudo npm install -g corepack
    fi

    corepack enable
    corepack prepare pnpm@latest --activate
}

setup_git() {
    git config --global core.editor "code --wait"
}

install_ghostty() {
    sudo dnf copr enable -y scottames/ghostty
    sudo dnf install -y ghostty
}

install_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

    sudo dnf install -y code
}

setup_zsh() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    mkdir -p "$zsh_custom/themes"

    if [[ ! -d "$zsh_custom/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
    fi

    # Set zsh as default shell
    chsh -s "$(command -v zsh)"
}

install_fonts() {
    local fonts_dir="$HOME/.local/share/fonts"
    local jb_zip="$fonts_dir/JetBrainsMono.zip"
    local jb_tmp_dir="$fonts_dir/jetbrainsmono_nf_tmp"

    mkdir -p "$fonts_dir"

    # MesloLGS NF fonts for powerlevel10k
    curl -fLo "$fonts_dir/MesloLGS NF Regular.ttf" \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Bold.ttf" \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Italic.ttf" \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -fLo "$fonts_dir/MesloLGS NF Bold Italic.ttf" \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    # JetBrains Mono Nerd Font
    curl -fLo "$jb_zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

    rm -rf "$jb_tmp_dir"
    mkdir -p "$jb_tmp_dir"

    unzip -o "$jb_zip" -d "$jb_tmp_dir"
    find "$jb_tmp_dir" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$fonts_dir/" \;

    rm -rf "$jb_tmp_dir" "$jb_zip"

    fc-cache -f "$fonts_dir"
}

main() {
    install_google_chrome
    install_dnf_packages
    install_orchis_theme
    install_bibata_cursor
    install_ghostty
    install_vscode
    setup_node_tools
    setup_git
    setup_zsh
    install_fonts
}

main
