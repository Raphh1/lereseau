```sh
[raph@localhost ~]$ sudo dnf install mariadb-server
[sudo] password for raph:
Rocky Linux 9 - BaseOS                                                                            7.8 kB/s | 3.6 kB     00:00
Rocky Linux 9 - AppStream                                                                          12 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                                                         3.0 MB/s | 6.4 MB     00:02
Rocky Linux 9 - Extras                                                                            8.3 kB/s | 2.9 kB     00:00
Rocky Linux 9 - Extras                                                                             12 kB/s | 8.5 kB     00:00
Package mariadb-server-3:10.5.16-2.el9_0.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[raph@localhost ~]$ systemctl enable mariadb
Failed to enable unit: Access denied
[raph@localhost ~]$ sudo systemctl enable mariadb
[raph@localhost ~]$ sudo systemctl start mariadb
[raph@localhost ~]$ sudo mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] ^C
Aborting!

Cleaning up...
[raph@localhost ~]$ sudo mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] n
 ... skipping.

You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n]
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n]
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n]
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
[raph@localhost ~]$
```

## Faites en sorte que le service de base de données démarre quand la machine s'allume.

## Port utilisé par MariaDB

```sh
[raph@localhost ~]$ ss -alnpt | grep 3306
LISTEN 0      80                 *:3306            *:*
```

## Processus liés à MariaDB

```bash
[raph@localhost ~]$ ps -aux | grep maria
mysql        790  0.0  5.2 1085076 96280 ?       Ssl  09:18   0:00 /usr/libexec/mariadbd --basedir=/usr
raph       1509  0.0  0.1   6412  2112 pts/0    S+   10:32   0:00 grep --color=auto maria
```

## Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données

```sh
MariaDB [(none)]> SELECT User FROM mysql.user;
+-------------+
| User        |
+-------------+
| nextcloud   |
| nextcloud   |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
5 rows in set (0.001 sec)
```

Initialisation de la DB
```
[raph@localhost ~]$ sudo dnf install mariadb-server
[sudo] password for raph:
Rocky Linux 9 - BaseOS                                                                            7.8 kB/s | 3.6 kB     00:00
Rocky Linux 9 - AppStream                                                                          12 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                                                         3.0 MB/s | 6.4 MB     00:02
Rocky Linux 9 - Extras                                                                            8.3 kB/s | 2.9 kB     00:00
Rocky Linux 9 - Extras                                                                             12 kB/s | 8.5 kB     00:00
Package mariadb-server-3:10.5.16-2.el9_0.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[raph@localhost ~]$ systemctl enable mariadb
Failed to enable unit: Access denied
[raph@localhost ~]$ sudo systemctl enable mariadb
[raph@localhost ~]$ sudo systemctl start mariadb
[raph@localhost ~]$ sudo mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] ^C
Aborting!

Cleaning up...
[raph@localhost ~]$ sudo mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] n
 ... skipping.

You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n]
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n]
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n]
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
[raph@localhost ~]$ ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.9 106776 16628 ?        Ss   09:18   0:00 /usr/lib/systemd/systemd --switched-root --system --deserializeroot           2  0.0  0.0      0     0 ?        S    09:18   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        I<   09:18   0:00 [rcu_gp]
root           4  0.0  0.0      0     0 ?        I<   09:18   0:00 [rcu_par_gp]
root           6  0.0  0.0      0     0 ?        I<   09:18   0:00 [kworker/0:0H-events_highpri]
root           8  0.0  0.0      0     0 ?        I    09:18   0:00 [kworker/u2:0-flush-253:0]
root           9  0.0  0.0      0     0 ?        I<   09:18   0:00 [mm_percpu_wq]
root          10  0.0  0.0      0     0 ?        S    09:18   0:00 [rcu_tasks_kthre]
root          11  0.0  0.0      0     0 ?        S    09:18   0:00 [rcu_tasks_rude_]
root          12  0.0  0.0      0     0 ?        S    09:18   0:00 [rcu_tasks_trace]
root          13  0.0  0.0      0     0 ?        S    09:18   0:00 [ksoftirqd/0]
root          14  0.0  0.0      0     0 ?        I    09:18   0:00 [rcu_preempt]
root          15  0.0  0.0      0     0 ?        S    09:18   0:00 [migration/0]
root          16  0.0  0.0      0     0 ?        S    09:18   0:00 [cpuhp/0]
root          18  0.0  0.0      0     0 ?        S    09:18   0:00 [kdevtmpfs]
root          19  0.0  0.0      0     0 ?        I<   09:18   0:00 [netns]
root          20  0.0  0.0      0     0 ?        I<   09:18   0:00 [inet_frag_wq]
root          21  0.0  0.0      0     0 ?        S    09:18   0:00 [kauditd]
root          22  0.0  0.0      0     0 ?        S    09:18   0:00 [khungtaskd]
root          23  0.0  0.0      0     0 ?        S    09:18   0:00 [oom_reaper]
root          24  0.0  0.0      0     0 ?        I<   09:18   0:00 [writeback]
root          25  0.0  0.0      0     0 ?        S    09:18   0:00 [kcompactd0]
root          26  0.0  0.0      0     0 ?        SN   09:18   0:00 [ksmd]
root          27  0.0  0.0      0     0 ?        SN   09:18   0:00 [khugepaged]
root          28  0.0  0.0      0     0 ?        I<   09:18   0:00 [cryptd]
root          29  0.0  0.0      0     0 ?        I<   09:18   0:00 [kintegrityd]
root          30  0.0  0.0      0     0 ?        I<   09:18   0:00 [kblockd]
root          31  0.0  0.0      0     0 ?        I<   09:18   0:00 [blkcg_punt_bio]
root          32  0.0  0.0      0     0 ?        I<   09:18   0:00 [tpm_dev_wq]
root          33  0.0  0.0      0     0 ?        I<   09:18   0:00 [md]
root          34  0.0  0.0      0     0 ?        I<   09:18   0:00 [edac-poller]
root          35  0.0  0.0      0     0 ?        S    09:18   0:00 [watchdogd]
root          36  0.0  0.0      0     0 ?        I    09:18   0:00 [kworker/u2:1-events_unbound]
root          37  0.0  0.0      0     0 ?        I<   09:18   0:00 [kworker/0:1H-kblockd]
root          38  0.0  0.0      0     0 ?        S    09:18   0:00 [kswapd0]
root          39  0.0  0.0      0     0 ?        I<   09:18   0:00 [kthrotld]
root          43  0.0  0.0      0     0 ?        I<   09:18   0:00 [acpi_thermal_pm]
root          45  0.0  0.0      0     0 ?        I<   09:18   0:00 [kmpath_rdacd]
root          46  0.0  0.0      0     0 ?        I<   09:18   0:00 [kaluad]
root          47  0.0  0.0      0     0 ?        I<   09:18   0:00 [mld]
root          48  0.0  0.0      0     0 ?        I<   09:18   0:00 [ipv6_addrconf]
root          49  0.0  0.0      0     0 ?        I<   09:18   0:00 [kstrp]
root          63  0.0  0.0      0     0 ?        I<   09:18   0:00 [zswap-shrink]
root         181  0.0  0.0      0     0 ?        I<   09:18   0:00 [kworker/u3:0]
root         373  0.0  0.0      0     0 ?        I<   09:18   0:00 [ata_sff]
root         386  0.0  0.0      0     0 ?        S    09:18   0:00 [scsi_eh_0]
root         387  0.0  0.0      0     0 ?        I<   09:18   0:00 [scsi_tmf_0]
root         388  0.0  0.0      0     0 ?        S    09:18   0:00 [scsi_eh_1]
root         389  0.0  0.0      0     0 ?        S    09:18   0:00 [scsi_eh_2]
root         391  0.0  0.0      0     0 ?        I<   09:18   0:00 [scsi_tmf_1]
root         392  0.0  0.0      0     0 ?        I<   09:18   0:00 [scsi_tmf_2]
root         463  0.0  0.0      0     0 ?        I<   09:18   0:00 [kdmflush/253:0]
root         472  0.0  0.0      0     0 ?        I<   09:18   0:00 [kdmflush/253:1]
root         490  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfsalloc]
root         491  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs_mru_cache]
root         492  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-buf/dm-0]
root         493  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-conv/dm-0]
root         494  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-cil/dm-0]
root         495  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-reclaim/dm-]
root         496  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-gc/dm-0]
root         497  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-log/dm-0]
root         498  0.0  0.0      0     0 ?        S    09:18   0:00 [xfsaild/dm-0]
root         594  0.0  0.5  22264  9300 ?        Ss   09:18   0:00 /usr/lib/systemd/systemd-journald
root         607  0.0  0.6  33164 11476 ?        Ss   09:18   0:00 /usr/lib/systemd/systemd-udevd
root         608  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-buf/sda1]
root         609  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-conv/sda1]
root         610  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-cil/sda1]
root         611  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-reclaim/sda]
root         612  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-gc/sda1]
root         613  0.0  0.0      0     0 ?        I<   09:18   0:00 [xfs-log/sda1]
root         614  0.0  0.0      0     0 ?        S    09:18   0:00 [xfsaild/sda1]
root         632  0.0  0.1  18116  2332 ?        S<sl 09:18   0:00 /sbin/auditd
root         654  0.0  2.2 125020 41128 ?        Ssl  09:18   0:00 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
root         656  0.0  0.3 160260  6948 ?        Ssl  09:18   0:00 /usr/sbin/rsyslogd -n
chrony       659  0.0  0.1  84408  3320 ?        S    09:18   0:00 /usr/sbin/chronyd -F 2
root         664  0.0  0.6  28348 10988 ?        Ss   09:18   0:00 /usr/lib/systemd/systemd-logind
dbus         668  0.0  0.2   9860  4488 ?        Ss   09:18   0:00 /usr/bin/dbus-broker-launch --scope system --audit
dbus         672  0.0  0.1   4980  2804 ?        S    09:18   0:00 dbus-broker --log 4 --controller 9 --machine-id 1819233db522482root         684  0.0  1.0 257164 19576 ?        Ssl  09:18   0:00 /usr/sbin/NetworkManager --no-daemon
root         693  0.0  0.5  16120  9636 ?        Ss   09:18   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         714  0.0  0.2   8580  3796 ?        Ss   09:18   0:00 /usr/sbin/crond -n
root         715  0.0  0.3  12596  6528 ?        Ss   09:18   0:00 login -- raph
mysql        790  0.0  5.2 1085076 96280 ?       Ssl  09:18   0:00 /usr/libexec/mariadbd --basedir=/usr
root         824  0.0  0.0      0     0 ?        I<   09:18   0:00 [ttm_swap]
root         828  0.0  0.0      0     0 ?        S    09:18   0:00 [irq/18-vmwgfx]
root         829  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc0]
root         831  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc1]
root         833  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc2]
root         837  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc3]
root         838  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc4]
root         840  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc5]
root         841  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc6]
root         844  0.0  0.0      0     0 ?        S    09:18   0:00 [card0-crtc7]
raph       1307  0.0  0.7  21680 13404 ?        Ss   09:21   0:00 /usr/lib/systemd/systemd --user
raph       1309  0.0  0.2 106708  5152 ?        S    09:21   0:00 (sd-pam)
raph       1316  0.0  0.2   7440  4276 tty1     Ss+  09:21   0:00 -bash
root        1338  0.0  0.6  19300 11804 ?        Ss   09:22   0:00 sshd: raph [priv]
raph       1342  0.0  0.3  19300  6604 ?        S    09:22   0:00 sshd: raph@pts/0
raph       1343  0.0  0.2   7440  4308 pts/0    Ss   09:22   0:00 -bash
root        1473  0.0  0.0      0     0 ?        I    09:47   0:01 [kworker/0:1-events]
root        1496  0.0  0.1   5648  2440 ?        Ss   10:01   0:00 /usr/sbin/anacron -s
root        1503  0.0  0.0      0     0 ?        I    10:25   0:00 [kworker/0:0-ata_sff]
root        1506  0.0  0.0      0     0 ?        I    10:31   0:00 [kworker/0:2-ata_sff]
raph       1507  0.0  0.3  18020  6368 pts/0    R+   10:32   0:00 ps -aux
[raph@localhost ~]$ ps -aux | grep maria
mysql        790  0.0  5.2 1085076 96280 ?       Ssl  09:18   0:00 /usr/libexec/mariadbd --basedir=/usr
raph       1509  0.0  0.1   6412  2112 pts/0    S+   10:32   0:00 grep --color=auto maria
[raph@localhost ~]$ ss -alnpt
State          Recv-Q         Send-Q                 Local Address:Port                 Peer Address:Port         Process
LISTEN         0              128                          0.0.0.0:22                        0.0.0.0:*
LISTEN         0              80                                 *:3306                            *:*
LISTEN         0              128                             [::]:22                           [::]:*
[raph@localhost ~]$ ss -alnpt | grep 3306
LISTEN 0      80                 *:3306            *:*
[raph@localhost ~]$ sudo mysql -u root -p
[sudo] password for raph:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 12
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> ls
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'ls' at line 1
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.001 sec)

MariaDB [(none)]> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [mysql]> show tables;
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| column_stats              |
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| global_priv               |
| gtid_slave_pos            |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| index_stats               |
| innodb_index_stats        |
| innodb_table_stats        |
| plugin                    |
| proc                      |
| procs_priv                |
| proxies_priv              |
| roles_mapping             |
| servers                   |
| slow_log                  |
| table_stats               |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| transaction_registry      |
| user                      |
+---------------------------+
31 rows in set (0.000 sec)

MariaDB [mysql]> exit
Bye
[raph@localhost ~]$ sudo mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> exit
Bye
[raph@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9d:59:6b brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 81139sec preferred_lft 81139sec
    inet6 fe80::a00:27ff:fe9d:596b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:34:a6:cb brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.110/24 brd 192.168.56.255 scope global dynamic noprefixroute enp0s8
       valid_lft 439sec preferred_lft 439sec
    inet6 fe80::a00:27ff:fe34:a6cb/64 scope link
       valid_lft forever preferred_lft forever
[raph@localhost ~]$ sudo firewall-cmd --add-port tcp/3306 --permanent
[sudo] password for raph:
Error: INVALID_PORT: tcp
[raph@localhost ~]$ sudo firewall-cmd --add-port 3306/tcp --permanent
success
[raph@localhost ~]$ sudo firewall-cmd --reload
success
[raph@localhost ~]$ mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 15
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> SELECT host FROM mysql.user WHERE user = "nextcloud";
+-------------+
| Host        |
+-------------+
| 10.105.1.11 |
+-------------+
1 row in set (0.001 sec)

MariaDB [(none)]> GRANT ALL ON *.* to 'nextcloud'@'192.168.56.114'
    -> identified by "pewpewpew";
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> SELECT host FROM mysql.user WHERE user = "nextcloud";
+----------------+
| Host           |
+----------------+
| 10.105.1.11    |
| 192.168.56.114 |
+----------------+
2 rows in set (0.001 sec)

MariaDB [(none)]> exit
Bye
[raph@localhost ~]$ sudo nano /root/.my.cnf
[sudo] password for raph:
[raph@localhost ~]$
[raph@localhost ~]$ client_loop: send disconnect: Connection reset
```

## Install de PHP
## Install de tous les modules PHP nécessaires pour NextCloud

J'ai exécuté toutes les commandes avec succès.


## Récupérer NextCloud

J'ai `wget` le zip de NextCloud et unzip dans `/var/www/tp5_nextcloud/`.

### Adapter la configuration d'Apache

```
[raph@web conf.modules.d]$ cat 00-nextcloud.conf
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

### Exploration de la base de données

Connectez vous en ligne de commande à la base de données après l'installation terminée :

```
[raph@db ~]$ sudo mysql -u root -p
[sudo] password for raph:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 371
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

Déterminer combien de tables ont été crées par NextCloud lors de la finalisation de l'installation : 

On a 95 tables qui ont été créées par NextCloud. Autrement, en SQL :
```mysql
use nextcloud;
show tables;
select FOUND_ROWS();
```
