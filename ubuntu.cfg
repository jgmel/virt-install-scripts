
# System language
lang en_US

# Language modules to install
langsupport en_US

# System keyboard
keyboard us

# System mouse
mouse

# System timezone
timezone Europe/Madrid

# Root password
rootpw --disabled

# Initial user (will have sudo so no need for root)
user ubuntu --fullname "Ubuntu User" --password ChangeMe

# Reboot after installation
reboot

# Use text mode install
text

# Install OS instead of upgrade
install

# Installation media
url --url http://es.archive.ubuntu.com/ubuntu/

# System bootloader configuration
bootloader --location=mbr

# Clear the Master Boot Record
zerombr yes

# Partition clearing information
clearpart --all --initlabel
part /boot --fstype=ext4 --size=512 --asprimary
part pv.1 --grow --size=1 --asprimary
volgroup vg0 --pesize=4096 pv.1
logvol / --fstype ext4 --name=root --vgname=vg0 --size=1 --grow
logvol swap --name=swap --vgname=vg0 --size=2048 --maxsize=2048

# Don't install recommended items by default
preseed base-installer/install-recommends boolean false

#Firewall configuration
firewall --disabled

#Do not configure the X Window System
skipx

%packages
ubuntu-minimal
openssh-server

%pre

%post --nochroot
(
    sed -i "s;quiet;quiet console=ttyS0;" /target/etc/default/grub
    sed -i "s;quiet;quiet console=ttyS0;g" /target/boot/grub/grub.cfg
) 1> /target/root/post_install.log 2>&1
