#!/bin/sh
# Запускать как: sh setup.sh

echo "Активация проекта Sith для Lenovo LOQ..."

# 1. Скармливаем системе правильные репозитории
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf

# 2. Устанавливаем драйверы (Raptor Lake + RTX 4050) без вопросов
env ASSUME_ALWAYS_YES=YES pkg install -y drm-61-kmod nvidia-driver-550 webcamd cpu-microcode-intel devcpu-data

# 3. Настраиваем конфиг (С учетом твоего Probe ID)
cat <<EOF > /etc/rc.conf
hostname="Sith"
zfs_enable="YES"
kld_list="drm-61-kmod nvidia-modeset"
wlans_iwlwifi0="wlan0"
ifconfig_wlan0="WPA DHCP"
powerd_enable="YES"
webcamd_enable="YES"
# ПРАВИЛО СИТХА: SSH ЗАПРЕЩЕН
sshd_enable="NO"
EOF

# 4. Удаляем SSH ключи на всякий случай
rm -rf /etc/ssh/ssh_host_*

echo "Готово! Перезагрузись и Sith оживет."
