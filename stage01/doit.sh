#!/bin/bash

if [ $1 = "xen" ]; then
./bundleit.sh ../share/euca-ubuntu-9.04-x86_64/xen-kernel/vmlinuz-2.6.27.21-0.1-xen ../share/euca-ubuntu-9.04-x86_64/xen-kernel/initrd-2.6.27.21-0.1-xen ../share/euca-ubuntu-9.04-x86_64/ubuntu.9-04.x86-64.img
else
./bundleit.sh ../share/euca-ubuntu-9.04-x86_64/kvm-kernel/vmlinuz-2.6.28-11-generic ../share/euca-ubuntu-9.04-x86_64/kvm-kernel/initrd.img-2.6.28-11-generic ../share/euca-ubuntu-9.04-x86_64/ubuntu.9-04.x86-64.img
fi
