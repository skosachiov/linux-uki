#!/bin/bash

KERNEL_VERSION=$(basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

ukify build \
	--linux=/boot/vmlinuz-$KERNEL_VERSION \
	--initrd=/boot/initrd.img-$KERNEL_VERSION \
	--cmdline='quiet rw' \
	--output=src/linux-uki-$KERNEL_VERSION.efi

