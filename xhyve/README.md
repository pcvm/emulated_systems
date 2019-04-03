# xhyve emulated systems

xhyve is an x86 virtualisation tool based on the FreeBSD virtualisation tool bhyve. It can be installed using Homebrew for macOS.

(1) Purpose: install a virtualised ubuntu linux in xhyve in macOS

* Pre-requisite: homebrew
  - See URL https://brew.sh/ for Homebrew install instructions

* Running FreeBSD on macOS
  - Running FreeBSD on OSX https://dan.langille.org/2018/10/02/running-freebsd-on-osx-using-xhyve-a-port-of-bhyve/ (Oct-2018)
  - These instructions are by Dan Langille https://dan.langille.org/
  
* Running Linux on macOS
  - Overview of the process leading up to a bootable system:
    - Obtain the initial linux and initrd executables and a cd/dvd image so you can do an install;
    - Booting these up in qemu for an install from cd to disk, with an ISO image attached as a cd/dvd and another raw file attached as the new linux system disk, and then proceeding to do the install;
    - Before the shutdown at the end of the install, some “interesting” commands are used to obtain the final linux and initrd executables (the final system has more capable versions);
    - The final result is a new script to run your new system.
  - Introduction reading but don't try anything yet (keep an eye out for some variations on how to do things):
    - Running Ubuntu Linux on macOS https://github.com/rimusz-lab/xhyve-ubuntu
    - Xyhve Ubuntu 16.04 Server https://github.com/charlesportwoodii/xhyve-ubuntu/
  - If it is not already installed, install xhyve 
    - brew update 
    - brew install –HEAD xhyve
  - I keep xhyve emulated system files in $HOME/local/xhyve so to match, do 
    - mkdir -p $HOME/local/xhyve ; cd $HOME/local/xhyve
  - Download a consistent set of current install files into a subdirectory called boot using script Lget_files.sh (based on ideas from this Makefile). After downloading, run it via 
    - bash Lget_files.sh
  - Perform install with script Lcreate_on_macOS.sh using ideas from the install.sh script of Set up xhyve with Ubuntu 16.04 (we use mkfile to efficiently create a “disk” image). After downloading, run it via 
    - bash Lcreate_on_macOS.sh
  - The system can now be run with script Lrun.sh which displays NFS server examples, and preloads a terminal cut buffer (pbcopy) with useful NFS client and general commands. After downloading, run it via 
    - bash Lrun.sh -h # shows definitions provided in terminal copy buffer
    - bash Lrun.sh
  - Notes:
    - The Lrun.sh script enables X11 access from any client on the 192.168.64 subnet, so that a predefined DISPLAY value on the client will support X11 clients and even startlxde. It is assumed that you will only have internal systems using this IP number range.
    - It is worth inspecting the example alias commands that are preloaded into the terminal cut&paste buffer by Lrun.sh, as some provide convenient access to NFS shares from the 192.168.64.1 macOS host to the virtualised linux client. In fact, it might be quite easy to have all of the virtualised linux clients files NFS mounted and avoid the "blob" disk image (need to check whether the underlying macOS file system needs case sensitive file names).
