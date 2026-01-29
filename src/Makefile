KERNEL_VERSION=$(shell ls -1 /boot/vmlinuz-* | sort | tail -n1 | sed 's/\/boot\/vmlinuz-//')

all: linux-uki-$(KERNEL_VERSION).efi

linux-uki-$(KERNEL_VERSION).efi:
	./linux-uki.sh

install: all
	install -D linux-uki-$(KERNEL_VERSION).efi \
		$(DESTDIR)/usr/share/bin/linux-uki-$(KERNEL_VERSION).efi

clean:
	rm -f linux-uki-$(KERNEL_VERSION).efi

distclean: clean

uninstall:
	rm -f $(DESTDIR)/usr/share/bin/linux-uki-$(KERNEL_VERSION).efi

.PHONY: all install clean distclean uninstall
