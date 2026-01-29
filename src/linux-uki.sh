#!/bin/bash
set -e

# ukify genkey --pcr-private-key=tpm2-pcr-private-key-initrd.key --pcr-public-key=tpm2-pcr-public-key-initrd.pem
# export PCR_PRIVATE_KEY_INITRD=$(cat tpm2-pcr-private-key-initrd.key)
# export PCR_PUBLIC_KEY_INITRD=$(cat tpm2-pcr-public-key-initrd.pem)

# Build and Sign UKI for Debian with Secure Boot

echo "UKI Build and Sign Script"

# Detect kernel version
KERNEL_VERSION=$(ls -1 /boot/vmlinuz-* | sort | tail -n1 | sed 's/\/boot\/vmlinuz-//')
if [ -z "$KERNEL_VERSION" ]; then
    echo "ERROR: Could not detect kernel version"
    exit 1
fi

echo "Detected kernel version: $KERNEL_VERSION"

# Configuration
UNSIGNED_UKI="linux-uki-$KERNEL_VERSION.efi"
CMDLINE="root=/dev/mapper/crypt-root ro rd.auto rd.luks=1 \
rd.luks.options=tpm2-device=auto,tpm2-measure-pcr=yes rootflags=subvol=@rootfs quiet"

echo "Add components"
sed -i "s/Components:.*/Components: main contrib non-free non-free-firmware/g" /etc/apt/sources.list.d/debian.sources || true

echo "Installing required packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
    efitools \
    sbsigntool \
    linux-image-amd64 \
    linux-headers-amd64 \
    systemd \
    systemd-ukify \
    systemd-boot-efi \
    cryptsetup \
    dracut \
    clevis \
    clevis-dracut \
    clevis-luks \
    clevis-systemd \
    clevis-tpm2 \
    clevis-udisks2 \
    systemd-cryptsetup \
    tpm2-tools \
    tpm2-tss-engine-tools \
    tpm2-abrmd \
    cryptsetup-initramfs \
    efibootmgr \
    binutils \
    gnutls-bin \
    btrfs-progs \
    e2fsprogs \
    libext2fs2t64 \
    libterm-readline-gnu-perl \
    perl \
    intel-microcode \
    amd64-microcode

# Write crypttab
echo 'storage_crypt LABEL=storage_crypt none \
luks,discard,tpm2-device=auto,tpm2-measure-pcr=yes,tpm2-measure-keyslot-nvpcr=cryptsetup' > /etc/crypttab

# Build initrd
SCRIPT_DIR=$(dirname $0)
cp -f $SCRIPT_DIR/dracut.conf /etc/
dracut --include /etc/crypttab /etc/crypttab --no-hostonly --force --kver $KERNEL_VERSION /boot/initrd.img-$KERNEL_VERSION

# Start swtpm
# modprobe tpm_vtpm_proxy
# swtpm chardev -d --tpmstate dir=/tmp/tpmstate --tpm2 --vtpm-proxy

echo "Setting up signing environment"
SIGNING_DIR=$(mktemp -d)
trap 'rm -rf "$SIGNING_DIR"' EXIT

echo "$PCR_PRIVATE_KEY_INITRD" > "$SIGNING_DIR/tpm2-pcr-private-key-initrd.key"
chmod 600 "$SIGNING_DIR/tpm2-pcr-private-key-initrd.key"

echo "$PCR_PUBLIC_KEY_INITRD" > "$SIGNING_DIR/tpm2-pcr-public-key-initrd.pem"
chmod 600 "$SIGNING_DIR/tpm2-pcr-public-key-initrd.pem"

echo "Building UKI"
ukify build \
    --linux="/boot/vmlinuz-$KERNEL_VERSION" \
    --initrd="/boot/initrd.img-$KERNEL_VERSION" \
    --pcr-private-key="$SIGNING_DIR/tpm2-pcr-private-key-initrd.key" \
    --pcr-public-key="$SIGNING_DIR/tpm2-pcr-public-key-initrd.pem" \
    --phases='enter-initrd' \
    --uname="$KERNEL_VERSION" \
    --cmdline="$CMDLINE" \
    --output="$UNSIGNED_UKI"
#    --pcr-private-key="$SIGNING_DIR/tpm2-pcr-private-key-system.key" \
#    --pcr-public-key="assets/esl/tpm2-pcr-public-key-system.pem" \
#    --phases="enter-initrd:leave-initrd enter-initrd:leave-initrd:sysinit enter-initrd:leave-initrd:sysinit:ready" \

