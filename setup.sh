#!/bin/sh
set -eu

RC_CONF=/etc/rc.conf

confirm() {
    printf '%s [y/N] ' "$1"
    IFS= read -r answer || answer=
    case "${answer:-}" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

if [ "$(uname -s)" != "FreeBSD" ]; then
    echo "This installer only runs on FreeBSD." >&2
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root (for example, from a root shell)." >&2
    exit 1
fi

cat <<'NOTICE'
Sith setup for Lenovo LOQ 15IRX9
This will install graphics, webcam, and Intel microcode packages and update
selected settings in /etc/rc.conf. Existing settings will be backed up first.
Wi-Fi configuration and credentials are not changed.
NOTICE

if ! confirm "Continue?"; then
    echo "Cancelled; no changes were made."
    exit 0
fi

# These package names follow the current FreeBSD Handbook guidance.
# pkg asks for confirmation before installing packages.
pkg install drm-kmod nvidia-drm-kmod webcamd devcpu-data

backup_dir="/var/backups/sith-setup-$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup_dir"
if [ -f "$RC_CONF" ]; then
    cp -p "$RC_CONF" "$backup_dir/rc.conf"
    echo "Backed up $RC_CONF to $backup_dir/rc.conf"
else
    echo "No existing $RC_CONF was found; sysrc will create it."
fi

# Remove module names used by the old profile and add the current module names.
sysrc -f "$RC_CONF" 'kld_list-=drm-61-kmod'
sysrc -f "$RC_CONF" 'kld_list-=nvidia-modeset'
sysrc -f "$RC_CONF" 'kld_list+=i915kms'
sysrc -f "$RC_CONF" 'kld_list+=nvidia-drm'
sysrc -f "$RC_CONF" webcamd_enable=YES
sysrc -f "$RC_CONF" microcode_update_enable=YES
sysrc -f "$RC_CONF" powerd_enable=YES
sysrc -f "$RC_CONF" hostname=Sith

if confirm "Disable the SSH server? This prevents remote SSH access."; then
    sysrc -f "$RC_CONF" sshd_enable=NO
else
    echo "SSH setting left unchanged."
fi

cat <<NOTICE

Setup finished. Review $RC_CONF and reboot when ready.
Backup: $backup_dir/rc.conf (if an rc.conf existed)
Wi-Fi was not configured. Confirm the interface name and set up
/etc/wpa_supplicant.conf before enabling a wireless interface.
Hardware support still needs to be checked on the target laptop.
NOTICE
