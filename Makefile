KERNEL_VERSION := $(shell basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

all: run

run:
	ukify build \
		--linux=/boot/vmlinuz-${KERNEL_VERSION} \
		--initrd=/boot/initrd.img-${KERNEL_VERSION} \
		--cmdline='quiet rw'

deps:
	apt-get install -y linux-image-amd64 systemd-ukify
	# pip install -r requirements.txt

clean:
	rm -f *.log output.txt

.PHONY: all run deps clean
