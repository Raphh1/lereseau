```
[chval@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for chval:
  Physical volume "/dev/sdb" successfully created.
[chval@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
[chval@storage ~]$ sudo pvdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  "/dev/sdb" is a new physical volume of "2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name
  PV Size               2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               EZ24yN-B9y9-GFSQ-nN0g-SFNV-i3tv-iWj2v0

[chval@storage ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created
[chval@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  VG   #PV #LV #SN Attr   VSize  VFree
  data   1   0   0 wz--n- <2.00g <2.00g
[chval@storage ~]$ sudo vgdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  --- Volume group ---
  VG Name               data
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <2.00 GiB
  PE Size               4.00 MiB
  Total PE              511
  Alloc PE / Size       0 / 0
  Free  PE / Size       511 / <2.00 GiB
  VG UUID               f8QwNj-9sKv-pFey-q0Y5-RX1S-nVju-12mgP1

[chval@storage ~]$ mkfs -t ext4 /dev/sdb2
mke2fs 1.46.5 (30-Dec-2021)
The file /dev/sdb2 does not exist and no size was specified.
[chval@storage ~]$ mkfs -t ext4 /dev/data/cuite
mke2fs 1.46.5 (30-Dec-2021)
The file /dev/data/cuite does not exist and no size was specified.
[chval@storage ~]$ sudo lvcreate -L 2G data -n ma_data_freeeeeeeeeeer
  Volume group "data" has insufficient free space (511 extents): 512 required.
[chval@storage ~]$ sudo lvcreate -L 512M data -n ma_data_freeeeeeeeeeer
  Logical volume "ma_data_freeeeeeeeeeer" created.
[chval@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  LV                     VG   Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ma_data_freeeeeeeeeeer data -wi-a----- 512.00m
[chval@storage ~]$ sudo lvdisplay
[sudo] password for chval:
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBd297fa66-0689f16a_ PVID myDd4nfRa07MtYn0R1RrBOttGQmKZrX5 last seen on /dev/sda2 not found.
  --- Logical volume ---
  LV Path                /dev/data/ma_data_freeeeeeeeeeer
  LV Name                ma_data_freeeeeeeeeeer
  VG Name                data
  LV UUID                ElzS77-NYes-fTQk-CKmP-nsNW-lm4g-f1Ha2B
  LV Write Access        read/write
  LV Creation host, time storage.tp4.linux, 2022-12-13 11:49:29 +0100
  LV Status              available
  # open                 0
  LV Size                512.00 MiB
  Current LE             128
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

[chval@storage ~]$ mkfs -t ext4 /dev/data/ma_data_freeeeeeeeeeer
mke2fs 1.46.5 (30-Dec-2021)
mkfs.ext4: Permission denied while trying to determine filesystem size
[chval@storage ~]$ sudo mkfs -t ext4 /dev/data/ma_data_freeeeeeeeeeer
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 131072 4k blocks and 32768 inodes
Filesystem UUID: 3a1a5bc9-eaa8-47fc-97a7-993594dce85e
Superblock backups stored on blocks:
        32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

[chval@storage ~]$ mount /dev/data/ma_data_freeeeeeeeeeer /mnt/data1
mount: /mnt/data1: mount point does not exist.
[chval@storage ~]$ sudo mount /dev/data/ma_data_freeeeeeeeeeer /mnt/data1
mount: /mnt/data1: mount point does not exist.
[chval@storage ~]$ mkdir /mnt/data1
mkdir: cannot create directory ‘/mnt/data1’: Permission denied
[chval@storage ~]$ sudo mkdir /mnt/data1
[chval@storage ~]$ sudo mount /dev/data/ma_data_freeeeeeeeeeer /mnt/data1
[chval@storage ~]$ mount
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=889504k,nr_inodes=222376,mode=755,inode64)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel,inode64)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,size=363540k,nr_inodes=819200,mode=755,inode64)
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,seclabel,nsdelegate,memory_recursiveprot)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime,seclabel)
none on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime,mode=700)
/dev/mapper/rl-root on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,nosuid,noexec,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=34,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=17177)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,seclabel,pagesize=2M)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime,seclabel)
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime,seclabel)
tracefs on /sys/kernel/tracing type tracefs (rw,nosuid,nodev,noexec,relatime,seclabel)
fusectl on /sys/fs/fuse/connections type fusectl (rw,nosuid,nodev,noexec,relatime)
configfs on /sys/kernel/config type configfs (rw,nosuid,nodev,noexec,relatime)
/dev/sda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=181768k,nr_inodes=45442,mode=700,uid=1000,gid=1000,inode64)
/dev/mapper/data-ma_data_freeeeeeeeeeer on /mnt/data1 type ext4 (rw,relatime,seclabel)
[chval@storage ~]$ df -h
Filesystem                               Size  Used Avail Use% Mounted on
devtmpfs                                 869M     0  869M   0% /dev
tmpfs                                    888M     0  888M   0% /dev/shm
tmpfs                                    356M  5.0M  351M   2% /run
/dev/mapper/rl-root                      6.2G  1.2G  5.1G  19% /
/dev/sda1                               1014M  272M  743M  27% /boot
tmpfs                                    178M     0  178M   0% /run/user/1000
/dev/mapper/data-ma_data_freeeeeeeeeeer  488M   24K  452M   1% /mnt/data1
[chval@storage ~]$ sudo nano /etc/fstab
[chval@storage ~]$ sudo nano /etc/fstab
[chval@storage ~]$ sudo nano /etc/fstab
[chval@storage ~]$ sudo umount /mnt/data1
[chval@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/data1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/mnt/data1               : successfully mounted
[chval@storage ~]$ sudo reboot
[chval@storage ~]$ Connection to 192.168.56.113 closed by remote host.
Connection to 192.168.56.113 closed.
```

### Monter la partition
```
[chval@storage ~]$ sudo mount /dev/mapper/data-ma_data_freeeeeeeeeeer /storage
```

Preuve avec une commande que la partition est bien montée :
```
[chval@storage ~]$ df -h | grep /storage
/dev/mapper/data-ma_data_freeeeeeeeeeer  488M   24K  452M   1% /storage
```

Prouvez que vous pouvez lire et écrire des données sur cette partition :
```
[chval@storage storage]$ sudo nano caput.wav
[chval@storage storage]$ cat caput.wav
salut
```

Ajout du disque dans `/etc/fstab`:
```
[chval@storage storage]$ cat /etc/fstab | grep /storage
/dev/data/ma_data_freeeeeeeeeeer /storage ext4 defaults 0 0
```

# Partie 2 : Serveur de partage de fichiers

### Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`

```
[chval@storage storage]$ sudo nano /etc/exports
[chval@storage storage]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[chval@storage storage]$ sudo systemctl start nfs-server
[chval@storage storage]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2023-01-02 11:00:29 CET; 7s ago
    Process: 14524 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 14525 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
    Process: 14543 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=e>
   Main PID: 14543 (code=exited, status=0/SUCCESS)
        CPU: 12ms

Jan 02 11:00:28 storage.tp4.linux systemd[1]: Starting NFS server and services...
Jan 02 11:00:29 storage.tp4.linux systemd[1]: Finished NFS server and services.
[chval@storage storage]$ firewall-cmd --permanent --list-all | grep services
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[chval@storage storage]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client ssh
[chval@storage storage]$ firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[chval@storage storage]$ firewall-cmd --reload
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[chval@storage storage]$ firewall-cmd --reload
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[chval@storage storage]$ sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
success
success
success
success
[chval@storage storage]$ firewall-cmd --permanent --list-all | grep services
ERROR:dbus.proxies:Introspect error on :1.3:/org/fedoraproject/FirewallD1: dbus.exceptions.DBusException: org.fedoraproject.FirewallD1.NotAuthorizedException: Not Authorized(uid): org.fedoraproject.FirewallD1.info
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[chval@storage storage]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
[chval@storage storage]$ sudo nano /etc/exports
[chval@storage storage]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9d:59:6b brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 81451sec preferred_lft 81451sec
    inet6 fe80::a00:27ff:fe9d:596b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:5b:37:dc brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.113/24 brd 192.168.56.255 scope global dynamic noprefixroute enp0s8
       valid_lft 451sec preferred_lft 451sec
    inet6 fe80::a00:27ff:fe5b:37dc/64 scope link
       valid_lft forever preferred_lft forever
[chval@storage storage]$ sudo nano /etc/exports
[sudo] password for chval:
[chval@storage storage]$ sudo systemctl restart nfs-server
[chval@storage storage]$
```

## Contenu du fichier `/etc/exports` dans le compte-rendu notamment

```
[chval@storage ~]$ cat /etc/exports
/storage 192.168.56.110(rw,sync,no_subtree_check)
```

## Contenu du fichier `/etc/fstab` dans le compte-rendu notamment

```
[chval@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Fri Oct 14 10:50:35 2022
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=c4c593e9-b673-4240-a7e0-17cce31b2977 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
192.168.56.113:/storage/site_web_1    /var/www/site_web_1   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.56.113:/storage/site_web_2    /var/www/site_web_2   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## Partie 3 : Serveur web

