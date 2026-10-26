# Sith FreeBSD laptop profile

A configuration profile and setup helper for the Lenovo LOQ 15IRX9
(Intel Core i7-13650HX, Intel integrated graphics, NVIDIA RTX 4050).

## What this repository delivers

The GitHub Actions workflow validates the shell syntax and publishes a
downloadable `sith-config.tar.gz` bundle containing this profile and
`setup.sh`. It does **not** build a bootable FreeBSD ISO.

## Run the setup helper

On the target FreeBSD laptop, inspect the files first, open a root shell, and
run:

```sh
sh setup.sh
```

The helper checks that it is running on FreeBSD as root and asks before making
changes. It installs `drm-kmod`, `nvidia-drm-kmod`, `webcamd`, and
`devcpu-data`. It backs up the existing `/etc/rc.conf` under
`/var/backups/sith-setup-*/rc.conf`, then uses `sysrc` to update selected
settings. It does not replace the whole file, change package repositories,
delete SSH host keys, or configure Wi-Fi credentials. The SSH server is
disabled only if you explicitly accept that prompt.

The profile targets one laptop, so review the selected modules and interface
names before applying it. The helper does not configure Wi-Fi: confirm the
actual interface name and set up `/etc/wpa_supplicant.conf` first.
[FreeBSD's graphics documentation](https://docs.freebsd.org/en/books/handbook/x11/)
describes `drm-kmod` for Intel graphics and the NVIDIA DRM driver options.

## Manual profile

`MYLAPTOP` is a suggested set of `rc.conf` values, not a complete replacement
for `/etc/rc.conf`. Apply only the settings appropriate for the installed
system. In particular, enable `zfs_enable` only if the system uses ZFS, and
disable SSH only if remote access is not needed.

## Validation status

GitHub Actions checks shell syntax and packages the profile. This cannot verify
Wi-Fi, graphics acceleration, camera, suspend/resume, thermals, or battery
life. Those still need testing on the target Lenovo LOQ. The repository does
not yet produce installation media.
