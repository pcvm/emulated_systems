#! /bin/bash
#
# Run xhyve using the kernel and initrd from the ubuntu install system, and
# with an ISO image of ubuntu install media as a source used to load up the
# new systems disk image. Ideas taken from
# https://gist.github.com/mowings/f7e348262d61eebf7b83754d3e028f6c
#
# Local definitions:
#
FSimg="Lubuntu16.img"
ISO=boot/xenial_mini.iso
#
# Choose modest disk (image) size = 16G
RAMGB=16

if [ ! -f "${FSimg}" ] ; then
    mkfile -nv ${RAMGB}g ${FSimg}
fi
echo "Using disk image ${FSimg}"
ls -al ${FSimg}
echo "Using boot area with"
ls -al boot

# from https://gist.github.com/mowings/f7e348262d61eebf7b83754d3e028f6c
#      (https://goo.gl/VGMiPf)
KERNEL="boot/linux"
INITRD="boot/initrd.gz"
CMDLINE="earlyprintk=serial console=ttyS0"

# Guest Config
MEM="-m 1G"
IMG_CD="-s 1,ahci-cd,${ISO}"
IMG_HDD="-s 2,virtio-blk,${FSimg}"
NET="-s 3:0,virtio-net,en0"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
ACPI="-A"

# and now run
sudo xhyve $ACPI $MEM $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD -f kexec,$KERNEL,$INITRD,"$CMDLINE"
exit

# Here is an example that includes a UUID which allows for consistent DHCP
# allocation of network IP number
    ACPI="-A"
    CPUs="-c 1"
     MEM="-m 2G"
PCI_DEV1="-s 0:0,hostbridge"
     NET="-s 2:0,virtio-net,en0"
  IMG_CD="-s 3,ahci-cd,${ISO}"
 IMG_HDD="-s 4,virtio-blk,${FSimg}"
PCI_DEV2="-s 31,lpc"
 LPC_DEV="-l com1,stdio"
    UUID="-U 805005AD-1F0D-4C9E-9AD5-0271B3765DF3"
#
xhyve $ACPI $CPUs $MEM $PCI_DEV1 $NET $IMG_CD $IMG_HDD $PCI_DEV2 $LPC_DEV $UUID -f kexec,$KERNEL,$INITRD,"$CMDLINE"
