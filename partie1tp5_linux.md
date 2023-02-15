## Installer le serveur Apache
```
[chval@localhost ~]$ sudo dnf install httpd php
[...]
```

## Démarrer le service Apache
```
[chval@localhost ~]$ sudo systemctl start httpd
[chval@localhost ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/httpd.service.d
             └─php-fpm.conf
     Active: active (running) since Tue 2023-01-03 15:44:55 CET; 18min ago
       Docs: man:httpd.service(8)
   Main PID: 1984 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 11118)
     Memory: 23.2M
        CPU: 362ms
     CGroup: /system.slice/httpd.service
             ├─1984 /usr/sbin/httpd -DFOREGROUND
             ├─1991 /usr/sbin/httpd -DFOREGROUND
             ├─1992 /usr/sbin/httpd -DFOREGROUND
             ├─1993 /usr/sbin/httpd -DFOREGROUND
             └─1994 /usr/sbin/httpd -DFOREGROUND

Jan 03 15:44:55 web.linux.tp5 systemd[1]: Starting The Apache HTTP Server...
Jan 03 15:44:55 web.linux.tp5 systemd[1]: Started The Apache HTTP Server.
Jan 03 15:44:55 web.linux.tp5 httpd[1984]: Server configured, listening on: port 80
```

**Faites en sorte qu'Apache démarre automatiquement au démarrage de la machine**

```
[chval@localhost ~]$ sudo systemctl enable httpd
```

```
[chval@localhost ~]$ ss -alnpt
State            Recv-Q           Send-Q                     Local Address:Port                     Peer Address:Port          Process
LISTEN           0                128                              0.0.0.0:22                            0.0.0.0:*
LISTEN           0                511                                    *:80                                  *:*
LISTEN           0                128                                 [::]:22                               [::]:*
```

## TEST

```
[chval@localhost ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/httpd.service.d
             └─php-fpm.conf
     Active: active (running) since Tue 2023-01-03 16:04:00 CET; 8min ago
       Docs: man:httpd.service(8)
   Main PID: 2255 (httpd)
     Status: "Total requests: 5; Idle/Busy workers 100/0;Requests/sec: 0.00945; Bytes served/sec:  74 B/sec"
      Tasks: 213 (limit: 11118)
     Memory: 23.0M
        CPU: 195ms
     CGroup: /system.slice/httpd.service
             ├─2255 /usr/sbin/httpd -DFOREGROUND
             ├─2256 /usr/sbin/httpd -DFOREGROUND
             ├─2257 /usr/sbin/httpd -DFOREGROUND
             ├─2258 /usr/sbin/httpd -DFOREGROUND
             └─2259 /usr/sbin/httpd -DFOREGROUND

Jan 03 16:04:00 web.linux.tp5 systemd[1]: httpd.service: Deactivated successfully.
Jan 03 16:04:00 web.linux.tp5 systemd[1]: Stopped The Apache HTTP Server.
Jan 03 16:04:00 web.linux.tp5 systemd[1]: Starting The Apache HTTP Server...
Jan 03 16:04:00 web.linux.tp5 systemd[1]: Started The Apache HTTP Server.
Jan 03 16:04:00 web.linux.tp5 httpd[2255]: Server configured, listening on: port 80

[chval@localhost ~]$ curl localhost
[page web]
```

Curl sur le PC : 
```
C:\Users\Cacahuète>curl 192.168.56.114
[page html]
```

## Le service Apache

Contenu du fichier :
```
[chval@localhost ~]$ cat /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#       [Service]
#       Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

## Déterminer sous quel utilisateur tourne le processus Apache

```
[chval@localhost ~]$ cat /etc/httpd/conf/httpd.conf | grep apache
User apache
Group apache
```

**Utilisez la commande `ps -ef` pour visualiser les processus en cours d'exécution et confirmer que apache tourne bien sous l'utilisateur mentionné dans le fichier de conf**

```
[chval@localhost ~]$ ps -ef | grep httpd
root        2255       1  0 16:03 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2256    2255  0 16:04 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2257    2255  0 16:04 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2258    2255  0 16:04 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2259    2255  0 16:04 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
chval       2596    1248  0 16:21 pts/0    00:00:00 grep --color=auto httpd
```

**Vérifiez avec un `ls -al` que tout son contenu est accessible en lecture à l'utilisateur mentionné dans le fichier de conf**

```
[chval@localhost testpage]$ ls -al
total 12
drwxr-xr-x.  2 root root   24 Jan  3 15:27 .
drwxr-xr-x. 87 root root 4096 Jan  3 15:27 ..
-rw-r--r--.  1 root root 7620 Jul 27 20:05 index.html
```

Le fichier `index.html` est en lecture pour tout le monde (et en écriture pour *root*).

## Changer l'utilisateur utilisé par Apache

Création d'un nouvel utilisateur :

```
[chval@localhost testpage]$ sudo useradd cousin -s /sbin/nologin --home-dir /usr/share/httpd
useradd: warning: the home directory /usr/share/httpd already exists.
useradd: Not copying any file from skel directory into it.
```

Modifiez la configuration d'Apache pour qu'il utilise ce nouvel utilisateur :

```
[chval@localhost testpage]$ cat /etc/httpd/conf/httpd.conf | grep User
User cousin
```

Redémarrez Apache :

```
[chval@localhost testpage]$ sudo systemctl restart httpd
```

## Faites en sorte que Apache tourne sur un autre port

Modifiez la configuration d'Apache pour lui demander d'écouter sur un autre port de votre choix :

```
[chval@localhost testpage]$ cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 8080
```

Ajouter le port dans le firewall :

```
[chval@localhost testpage]$ sudo firewall-cmd --add-port 8080/tcp --permanent
[sudo] password for chval:
success
```

Retirer l'ancien :

```
[chval@localhost testpage]$ sudo firewall-cmd --remove-port 80/tcp --permanent
success
```

Prouvez avec `ss` qu'Apache tourne bien sur le nouveau port :

```
[chval@localhost testpage]$ ss -alnpt
State            Recv-Q           Send-Q                     Local Address:Port                     Peer Address:Port          Process
LISTEN           0                128                              0.0.0.0:22                            0.0.0.0:*
LISTEN           0                511                                    *:8080                                *:*
LISTEN           0                128                                 [::]:22                               [::]:*
```

Le curl en local :

```
[chval@localhost testpage]$ curl localhost:8080
[page html]
```

Curl sur le PC : 

```
[chval@localhost testpage]$ sudo firewall-cmd --reload
[page html]
```

Voici le fichier [httpd.conf](files/httpd.conf).