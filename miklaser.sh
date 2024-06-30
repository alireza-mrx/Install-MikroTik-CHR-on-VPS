#!/bin/bash
wget https://uploadkon.ir/uploads/f6aa17_24chr-7-5-img.zip -O chr.img.zip
gunzip -c chr.img.zip > chr.img
mount -o loop,offset=33571840 chr.img /mnt
ADDRESS=`ip addr show ens160 | grep global | cut -d' ' -f 6 | head -n 1`
GATEWAY=`ip route list | grep default | cut -d' ' -f 3`
apt install -y pwgen coreutils
PASSWORD=$(pwgen 12 1)
echo "Username: admin"
echo "Password: $PASSWORD"
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
echo "/ip dns set server=1.1.1.1,8.8.8.8" >> /mnt/rw/autorun.scr
echo u > /proc/sysrq-trigger
dd if=chr.img bs=1024 of=/dev/sda
echo "sync disk"
echo s > /proc/sysrq-trigger
echo "Sleep 10 seconds"
read -t 10 -u 1
echo "Ok, reboot"
echo b > /proc/sysrq-trigger
