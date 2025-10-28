# Get kernel version
KERNEL_VERSION := $(shell basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

all: build

build: linux-uki-$(KERNEL_VERSION).efi

linux-uki-$(KERNEL_VERSION).efi:
	@echo "Building UKI for kernel: $(KERNEL_VERSION)"
	ukify build \
		--linux=/boot/vmlinuz-$(KERNEL_VERSION) \
		--initrd=/boot/initrd.img-$(KERNEL_VERSION) \
		--cmdline='quiet rw' \
		--output=linux-uki-$(KERNEL_VERSION).efi

install: all
	install -d $(DESTDIR)/usr/lib/linux-uki/
	install -m 644 linux-uki-$(KERNEL_VERSION).efi $(DESTDIR)/usr/lib/linux-uki/

clean:
	rm -f linux-uki-*.efi

distclean: clean

uninstall:
	rm -f $(DESTDIR)/usr/lib/linux-uki/linux-uki-*.efi

.PHONY: all build install clean distclean uninstall