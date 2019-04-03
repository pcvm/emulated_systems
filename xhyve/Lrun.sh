#! /bin/bash
#
# Run Ubuntu system in xhyve
# - assumes all files are in $HOME/local/xhyve
#   (adjust the next cd command if different)
# - assumes FSimg as left by Lcreate_on_macOS.sh script
# - makes use of macOS pbcopy to setup the Terminal cut&paste buffer with a sample
#   shell command to issue to the linux (this example is an NFS mount command)
#   (macOS pbcopy/pbpaste commands match the xclip package in unix)

DRYRUN=$1	# any arg1 such as "-h" just shows what would be run

# Use user ID in display of sample NFS setup commands, use emuDIS as emulated host value of DISPLAY
MYID=`whoami`
emuDIS=192.168.64.1`echo $DISPLAY|sed -e 's/[^:]*//'`	# ID of local DISPLAY that emulated host can access
echo "X server config:
  allowing access by any host on the 192.168.64 subnet created by xhyve
  clients will access $emuDIS"
xhost +192.168.64.8

# Local definitions:
#
FSimg="Lubuntu16.img"

cd $HOME/local/xhyve

echo "
Change currect directory to `pwd`
System image is:"
ls -al $FSimg

echo '
# *** NFS server example setup ***
# File /etc/exports
/Users/'${MYID}'/Desktop/no_backups /Users/'${MYID}'/local -mapall='${MYID}' -network=192.168.64 -mask 255.255.255.0

# *** Linux NFS mount example (preloaded to terminal paste buffer as alias mnthost) ***
sudo mount -t nfs -o nolock,rw 192.168.64.1:/Users/'${MYID}'/Desktop/no_backups /mnt

# *** Linux Shutdown command (preloaded to paste buffer as alias halt) ***
sudo halt
'
echo "alias mnthost='sudo mount -t nfs -o nolock,rw 192.168.64.1:/Users/${MYID}/Desktop/no_backups /mnt && df /mnt' ; alias mntlocal='(cd ~; mkdir -p local; sudo mount -t nfs -o nolock,rw 192.168.64.1:/Users/${MYID}/local ./local && df ./local)' ; alias halt='sudo halt' ; alias ty=more ; alias cls='stty sane ; stty dec -decctlq ; clear' ; alias df='df -H' ; alias du='du -k' ; alias e='emacs -nw' ; alias d='ls -al' ; alias dds='ls -Flao' ; alias fetch='curl -OR' ; alias h='history 28' ; echo ; echo df ; df ; echo ; date ; echo ; alias ; export DISPLAY=${emuDIS} ; echo DISPLAY=\$DISPLAY ; export TERM=xterm-256color ; resize" | pbcopy -

echo '****************************************'
echo "Preloading Terminal paste buffer:"
pbpaste
echo '****************************************'

#
# From https://gist.github.com/mowings/f7e348262d61eebf7b83754d3e028f6c
#
						#selfdoc machine kernel and init daemon
KERNEL="boot/vmlinuz-4.4.0-142-generic"		#selfdoc
INITRD="boot/initrd.img-4.4.0-142-generic"	#selfdoc
CMDLINE="earlyprintk=serial console=ttyS0 acpi=off root=/dev/vda1 ro"	#selfdoc
UUID="-U 805005AD-1F0D-4C9E-9AD5-0271B3765DF3"	#selfdoc set UUID to obtain a consistent ip address is assigned
# Guest Config
CPUs="-c 4"					#selfdoc set CPU and memory
MEM="-m 3G"
IMG_HDD="-s 2,virtio-blk,${FSimg}"		#selfdoc set main disk
NET="-s 3:0,virtio-net,en0"			#selfdoc network (can have more than 1)
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"				#selfdoc console
ACPI="-A"

echo
echo "System configuration"
cat $0 | egrep "[#]selfdoc" | sed -e 's/  / /g' -e 's/selfdoc / -> /' -e 's/\#selfdoc//' | egrep -v egrep
echo
echo "Use the predefined terminal paste to set NFS commands and other aliases"

if [ -n "$DRYRUN" ] ; then
  echo
  echo Dryrun: normal execution command will be
  echo
  echo sudo xhyve $UUID $ACPI $CPUs $MEM $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD -f kexec,$KERNEL,$INITRD,\"$CMDLINE\"
  echo
else
       sudo xhyve $UUID $ACPI $CPUs $MEM $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD -f kexec,$KERNEL,$INITRD,"$CMDLINE"
fi
