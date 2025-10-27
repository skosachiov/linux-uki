# Get kernel version
KERNEL_VERSION := $(shell basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

.PHONY: all build clean install

all: build

build:
	@echo "Building UKI for kernel: $(KERNEL_VERSION)"
	ukify build \
		--linux=/boot/vmlinuz-$(KERNEL_VERSION) \
		--initrd=/boot/initrd.img-$(KERNEL_VERSION) \
		--cmdline='quiet rw' \
		--output=linux-uki-$(KERNEL_VERSION).efi

install:
	install -d $(DESTDIR)/usr/lib/linux-uki/
	install -m 644 linux-uki-$(KERNEL_VERSION).efi $(DESTDIR)/usr/lib/linux-uki/

clean:
	rm -f linux-uki-*.efi

# Helper target for debian/rules
debian-build: build

debian-install: build install