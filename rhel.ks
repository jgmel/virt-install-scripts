install

url --url http://mirror.airenetworks.es/CentOS//7/os/x86_64/
repo --name="CentOS" --baseurl=http://mirror.airenetworks.es/CentOS/7/os/x86_64/ --cost=100
#
lang en_US.UTF-8
keyboard us

#network --device=eth0 --bootproto=dhcp --noipv6
%include /tmp/network.ks

rootpw password
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone Europe/Madrid
eula --agreed
bootloader --location=mbr --append="console=ttyS0 elevator=noop"

text
skipx
zerombr

clearpart --all --initlabel
part /boot --asprimary --fstype ext3 --size=512 
part / --asprimary --fstype xfs --size=1 --grow 
part swap --asprimary --size=512

auth  --useshadow  --enablemd5
firstboot --disabled

# reboot after installation completes	
reboot

%packages --nobase --ignoremissing --excludedocs
@core --nodefaults
-aic94xx-firmware*
-alsa-*
-biosdevname
-btrfs-progs*
-dhcp*
-dracut-network
-iprutils
-ivtv*
-iwl*firmware
-libertas*
-kexec-tools
-NetworkManager*
-plymouth*
-postfix
openssh-clients
%end


%pre
#!/bin/sh
for x in `cat /proc/cmdline`; do
  case $x in SERVERNAME*)
     eval $x
     echo "network --device eth0 --bootproto dhcp --hostname ${SERVERNAME}" > /tmp/network.ks
     ;;
  esac;
     done
%end

%post --log=/root/post-log

#Disable IPV6
/bin/echo "# IPv6 disabled" > /etc/sysctl.d/40-ipv6.conf
/bin/echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/40-ipv6.conf
/bin/echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/40-ipv6.conf
/bin/echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/40-ipv6.conf

#Grub2
sed -i 's#GRUB_TIMEOUT=.*#GRUB_TIMEOUT=1#' /etc/default/grub
echo 'GRUB_DISABLE_LINUX_UUID=true' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
%end

%addon com_redhat_kdump --disable
%end
