KERNEL_VERSION := $(shell basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

prefix = /usr/share

all: src/linux-uki-$(KERNEL_VERSION).efi

src/linux-uki-$(KERNEL_VERSION).efi: src/build-linux-uki.sh
	./$^

install: src/linux-uki-$(KERNEL_VERSION).efi
	install -D src/linux-uki-$(KERNEL_VERSION).efi \
                $(DESTDIR)$(prefix)/bin/linux-uki-$(KERNEL_VERSION).efi

clean:
	rm -f src/linux-uki-$(KERNEL_VERSION).efi

distclean: clean

uninstall:
	rm -f $(DESTDIR)$(prefix)/bin/linux-uki-$(KERNEL_VERSION).efi

.PHONY: all install clean distclean uninstall



