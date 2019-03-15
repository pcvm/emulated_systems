#! /bin/bash
#
# Retrieve install files from current images site for ubuntu/dists/xenial-updates
#
# Idea of taking latest netboot files seen in
# https://github.com/charlesportwoodii/xhyve-ubuntu/blob/master/Makefile

# Choose a mini ISO name that notes release
ISO=xenial_mini.iso
# Note script name so it can self-document
CMD=`pwd`/$0
#

mkdir -p boot ; cd boot

export XSRC=http://archive.ubuntu.com/ubuntu/dists/xenial-updates 

wget ${XSRC}/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz 
wget ${XSRC}/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux 
wget ${XSRC}/main/installer-amd64/current/images/netboot/mini.iso 
mv mini.iso $ISO

echo "Writing a Readme.txt file to show how these files were obtained"
(
    sep ()
    {
	ii=0 ; while [ $ii -lt 75 ] ; do printf '*' ; ii=`expr $ii + 1` ; done
	echo
    }
    date
    sep
    echo Ran the following script
    echo
    cat $CMD
    echo
    sep
    echo Obtained the following files
    echo
    ls -al
    echo
    sep
) > Readme.txt

cd ..

ls -al boot
