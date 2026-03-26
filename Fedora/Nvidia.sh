#!/usr/bin/env bash
set -euo pipefail

require_fedora() {
    if [[ ! -r /etc/os-release ]]; then
        echo "Cannot determine the current distribution." >&2
        exit 1
    fi

    . /etc/os-release

    if [[ "${ID:-}" != "fedora" ]]; then
        echo "This script is intended for Fedora systems only." >&2
        exit 1
    fi
}

require_mutable_fedora() {
    if [[ -e /run/ostree-booted ]]; then
        echo "Detected an rpm-ostree Fedora variant (Silverblue/Kinoite/etc.)." >&2
        echo "This script only supports mutable DNF-based Fedora systems." >&2
        exit 1
    fi

    if ! command -v dnf >/dev/null 2>&1; then
        echo "dnf is required but not available on this system." >&2
        exit 1
    fi
}

has_nvidia_gpu_sysfs() {
    local device_dir
    local vendor
    local class

    for device_dir in /sys/bus/pci/devices/*; do
        [[ -r "$device_dir/vendor" && -r "$device_dir/class" ]] || continue

        read -r vendor < "$device_dir/vendor"
        read -r class < "$device_dir/class"

        if [[ "$vendor" == "0x10de" && "$class" == 0x03* ]]; then
            return 0
        fi
    done

    return 1
}

check_nvidia_gpu() {
    if command -v lspci >/dev/null 2>&1; then
        if lspci | grep -qi 'nvidia'; then
            return
        fi
    fi

    if has_nvidia_gpu_sysfs; then
        return
    fi

    echo "No NVIDIA GPU detected. Exiting without installing drivers."
    exit 0
}

enable_rpmfusion() {
    sudo dnf install -y --refresh \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}

install_nvidia_drivers() {
    sudo dnf install -y --refresh \
        akmod-nvidia \
        xorg-x11-drv-nvidia \
        xorg-x11-drv-nvidia-cuda \
        xorg-x11-drv-nvidia-power \
        kernel-devel
}

warn_secure_boot() {
    if ! command -v mokutil >/dev/null 2>&1; then
        return
    fi

    if mokutil --sb-state 2>/dev/null | grep -qi 'enabled'; then
        cat <<'EOF'
Secure Boot appears to be enabled.
NVIDIA kernel modules from RPM Fusion may not load until you complete MOK key enrollment
or disable Secure Boot in your firmware settings.
EOF
    fi
}

print_pre_install_note() {
    cat <<'EOF'
Before installing NVIDIA drivers, it is recommended to fully update Fedora first:
  sudo dnf upgrade --refresh

This is especially helpful on a fresh install so the system can pick up the latest kernel
before akmods builds the NVIDIA module. Continuing anyway.

EOF
}

main() {
    print_pre_install_note
    require_fedora
    require_mutable_fedora
    check_nvidia_gpu
    warn_secure_boot
    enable_rpmfusion
    install_nvidia_drivers

    cat <<'EOF'
NVIDIA packages installed.

Recommended next steps:
1. Wait a minute or two so akmods can finish building the kernel module.
2. Reboot the system.
3. After reboot, verify with: nvidia-smi
EOF
}

main
