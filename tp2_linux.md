# I. Service SSH

## 1. Analyse de service

### S'assurer que le service `sshd` est bien démarré
Le service tourne bel et bien
```
[raph@localhost ~]$ sudo systemctl status sshd

● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendo>
     Active: active (running) since Mon 2022-12-05 11:26:51 CET; 16min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 693 (sshd)
      Tasks: 1 (limit: 11118)
     Memory: 5.6M
        CPU: 50ms
     CGroup: /system.slice/sshd.service
             └─693 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startu>
Dec 05 11:26:51 localhost systemd[1]: Starting OpenSSH server daemon...
Dec 05 11:26:51 localhost sshd[693]: Server listening on 0.0.0.0 port 22.
Dec 05 11:26:51 localhost sshd[693]: Server listening on :: port 22.
Dec 05 11:26:51 localhost systemd[1]: Started OpenSSH server daemon.
Dec 05 11:40:04 localhost.localdomain sshd[1236]: Accepted password for c>
Dec 05 11:40:04 localhost.localdomain sshd[1236]: pam_unix(sshd:session):>
```

### Analyser les processus liés au service SSH
```
[raph@localhost ~]$ ps -ef | grep sshd

root         693       1  0 11:26 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1236     693  0 11:39 ?        00:00:00 sshd: raph [priv]
chval       1240    1236  0 11:40 ?        00:00:00 sshd: raph@pts/0
```

### Déterminer le port sur lequel écoute le service SSH
```
[chval@localhost ~]$ sudo ss -alnpt
State          Recv-Q         Send-Q                   Local Address:Port                   Peer Address:Port         Process
LISTEN         0              128                            0.0.0.0:22                          0.0.0.0:*             users:(("sshd",pid=693,fd=3))
LISTEN         0              128                               [::]:22                             [::]:*             users:(("sshd",pid=693,fd=4))
```

Le port qu'écoute le service SSH est le port **22**.

### Consulter les logs du service SSH
Les logs du service :
```
[chval@localhost ~]$ journalctl -xe -u sshd
[...]
Dec 05 11:26:51 localhost systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 220.
Dec 05 11:26:51 localhost sshd[693]: Server listening on 0.0.0.0 port 22.
Dec 05 11:26:51 localhost sshd[693]: Server listening on :: port 22.
Dec 05 11:26:51 localhost systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 220.
Dec 05 11:40:04 localhost.localdomain sshd[1236]: Accepted password for chval from 192.168.56.109 port 59519 ssh2
Dec 05 11:40:04 localhost.localdomain sshd[1236]: pam_unix(sshd:session): session opened for user chval(uid=1000) by (uid=0)
```

Le fichier de log qui répertorie toutes les tentatives de connexion :
```
[chval@localhost log]$ sudo grep -r "sshd"
[...]

secure:Dec  5 11:04:45 localhost sshd[696]: Server listening on 0.0.0.0 port 22.
secure:Dec  5 11:04:45 localhost sshd[696]: Server listening on :: port 22.
secure:Dec  5 11:08:17 localhost sshd[691]: Server listening on 0.0.0.0 port 22.
secure:Dec  5 11:08:17 localhost sshd[691]: Server listening on :: port 22.
secure:Dec  5 11:10:20 localhost sshd[689]: Server listening on 0.0.0.0 port 22.
secure:Dec  5 11:10:20 localhost sshd[689]: Server listening on :: port 22.
secure:Dec  5 11:19:19 localhost sshd[691]: Server listening on 0.0.0.0 port 22.
secure:Dec  5 11:19:19 localhost sshd[691]: Server listening on :: port 22.
secure:Dec  5 11:24:52 localhost sshd[1396]: Accepted password for chval from 192.168.56.109 port 59495 ssh2

[...]
```

Utilisez une commande `tail` pour visualiser les 10 dernière lignes de ce fichier :
```
[chval@localhost log]$ sudo cat secure | tail -n 10
Dec  6 10:13:35 localhost login[702]: pam_unix(login:session): session opened for user chval(uid=1000) by (uid=0)
Dec  6 10:13:35 localhost login[702]: LOGIN ON tty1 BY chval
Dec  6 10:16:41 localhost sshd[1233]: Accepted password for chval from 192.168.56.109 port 51623 ssh2
Dec  6 10:16:41 localhost sshd[1233]: pam_unix(sshd:session): session opened for user chval(uid=1000) by (uid=0)
Dec  6 10:17:27 localhost sudo[1260]:   chval : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/grep -r sshd
Dec  6 10:17:27 localhost sudo[1260]: pam_unix(sudo:session): session opened for user root(uid=0) by chval(uid=1000)
Dec  6 10:17:27 localhost sudo[1260]: pam_unix(sudo:session): session closed for user root
Dec  6 10:19:38 localhost sudo[1268]:   chval : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat secure
Dec  6 10:19:38 localhost sudo[1268]: pam_unix(sudo:session): session opened for user root(uid=0) by chval(uid=1000)
Dec  6 10:19:38 localhost sudo[1268]: pam_unix(sudo:session): session closed for user root
```

## 2. Modification du service

### Identifier le fichier de configuration du serveur SSH

Le fichier de configuration semble être `/etc/ssh/ssh_config`.

### Modifier le fichier de conf

```
[chval@localhost ssh]$ echo $RANDOM
27007
```

Le numéro du loto est donc **27007**. On peut donc changer le port.

```
[chval@localhost ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 27007
```
Le port est bien changé

```
[chval@localhost ssh]$ sudo firewall-cmd --list-all
[sudo] password for chval:
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
[chval@localhost ssh]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success
[chval@localhost ssh]$ sudo firewall-cmd --add-port=27007/tcp --permanent
success
[chval@localhost ssh]$ sudo firewall-cmd --reload
success
```

Le port est bien ouvert :

```
[chval@localhost ssh]$ sudo firewall-cmd --list-all | grep ports
  ports: 27007/tcp
```

### Redémarrez le service

```
[chval@localhost ssh]$ sudo systemctl restart sshd
```

### Effectuer une connexion SSH sur le nouveau port

```
C:\Users\Cacahuète>ssh chval@192.168.56.111 -p 27007
chval@192.168.56.111's password:
Last login: Tue Dec  6 10:46:46 2022 from 192.168.56.109
[chval@localhost ~]$
```

Ca marche

# II. Service HTTP

## 1. Mise en place

### Installer le serveur NGINX

```
[chval@localhost ~]$ sudo dnf install nginx
Last metadata expiration check: 0:14:04 ago on Tue 06 Dec 2022 10:55:45 AM CET.
Dependencies resolved.
======================================================================================================================== Package                          Architecture          Version                          Repository                Size
========================================================================================================================Installing:
 nginx                            x86_64                1:1.20.1-13.el9                  appstream                 38 k
Installing dependencies:
 nginx-core                       x86_64                1:1.20.1-13.el9                  appstream                567 k
 nginx-filesystem                 noarch                1:1.20.1-13.el9                  appstream                 11 k
 rocky-logos-httpd                noarch                90.13-1.el9                      appstream                 24 k
```

### Démarrer le service NGINX

```
[chval@localhost ~]$ sudo systemctl start nginx
[chval@localhost ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
```

### Déterminer sur quel port tourne NGINX

```
[chval@localhost nginx]$ cat nginx.conf | grep listen
        listen       80;
        listen       [::]:80;
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
```

Il écoute sur le port **80**.

```
[chval@localhost nginx]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[chval@localhost nginx]$ sudo firewall-cmd --reload
success
```

Le port est ouvert dans le firewall.

### Déterminer les processus liés à l'exécution de NGINX

```
[chval@localhost nginx]$ ps -ef | grep nginx
root       11374       1  0 11:14 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11375   11374  0 11:14 ?        00:00:00 nginx: worker process
chval      11409    1509  0 11:22 pts/1    00:00:00 grep --color=auto nginx
```

### Euh wait

```
C:\Users\Cacahuète>curl http://192.168.56.111/ | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   714k      0 --:--:-- --:--:-- --:--:--  744k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
```

## 2. Analyser la conf de NGINX

### Déterminer le path du fichier de configuration de NGINX

```
[chval@localhost nginx]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 31 16:37 /etc/nginx/nginx.conf
```

### Trouver dans le fichier de conf

Le bloc server :
```
[chval@localhost nginx]$ cat /etc/nginx/nginx.conf | grep server -A 17
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

Inclusion d'autres fichiers :
```
[chval@localhost nginx]$ cat /etc/nginx/nginx.conf | grep module -A 1
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;
```

## 3. Déployer un nouveau site web

### Créer un site web

Dans ce dossier `/var/www/tp2_linux`, créez un fichier `index.html`.

```
[root@localhost tp2_linux]# cat index.html
<h1>MEOW mon premier serveur web</h1>
```

On demande au **loto** un port :
```
[chval@localhost tp2_linux]$ echo $RANDOM
28440
```

Je l'introduis dans la config
```
[chval@localhost tp2_linux]$ cat /etc/nginx/nginx.conf | grep listen
  listen 28440;
```

### Adapter la conf NGINX

J'ai retiré le bloc server
```
[chval@localhost tp2_linux]$ cat /etc/nginx/nginx.conf | grep server
```
*Ilépula*

Je vois dans le fichier de conf qu'il inclus tous les fichiers étant dans `/etc/nginx/conf.d` :

```
[chval@localhost nginx]$ cat nginx.conf | grep include
[...]
include /etc/nginx/conf.d/*.conf;
```

Alors je crée un fichier `website.conf` dans le dossier précédent :
```
[chval@localhost conf.d]$ sudo nano website.conf
```

ça donne ça : 
```
[chval@localhost nginx]$ cat conf.d/website.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 28440;

  root /var/www/tp2_linux;
}
```

### Visitez votre super site web

Le serveur répond bel et bien :
```
C:\Users\Cacahuète>curl http://192.168.56.111:28440/ | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    39  100    39    0     0   3368      0 --:--:-- --:--:-- --:--:--  3545
<h1>MEOW mon premier serveur web</h1>


```

# III. Your own services

## 2. Analyse des services existants

### Afficher le fichier de service SSH

On récupère le chemin du fichier service de **sshd** :
```
[chval@localhost ~]$ systemctl status sshd | grep loaded
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
```

Je met en évidence la ligne commençant par `ExecStart=` :

```
[chval@localhost ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

### Afficher le fichier de service NGINX

Je met en évidence la ligne commençant par `ExecStart=` :

```
[chval@localhost ~]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

## 3. Création de service

### Créez le fichier `/etc/systemd/system/tp2_nc.service`

Pour le numéro random : **17959** :

```
[chval@localhost ~]$ echo $RANDOM
17959
```

Le contenu du fichier :

```
[chval@localhost ~]$ cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 17959
```

### Indiquer au système qu'on a modifié les fichiers de service

```
[chval@localhost ~]$ sudo systemctl daemon-reload
```

### Démarrer notre service de ouf & vérifier que ça fonctionne

```
[chval@localhost ~]$ sudo systemctl start tp2_nc

[chval@localhost ~]$ systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Thu 2022-12-08 11:39:01 CET; 8s ago
   Main PID: 1343 (nc)
      Tasks: 1 (limit: 11118)
     Memory: 784.0K
        CPU: 2ms
     CGroup: /system.slice/tp2_nc.service
             └─1343 /usr/bin/nc -l 17959

Dec 08 11:39:01 localhost.localdomain systemd[1]: Started Super netcat tout fou.
```

Chut, il écoute à la porte (17959) !

```
[chval@localhost ~]$ sudo ss -alnpt | grep nc
LISTEN 0      10           0.0.0.0:17959      0.0.0.0:*    users:(("nc",pid=1343,fd=4))
LISTEN 0      10              [::]:17959         [::]:*    users:(("nc",pid=1343,fd=3))
```

Vérifier que juste ça marche en vous connectant au service depuis une autre VM

```
[chval@localhost ~]$ nc 192.168.56.112 17959
hello
world
```

```
[chval@localhost ~]$ systemctl status tp2_nc | grep nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
   Main PID: 1343 (nc)
     CGroup: /system.slice/tp2_nc.service
             └─1343 /usr/bin/nc -l 17959
Dec 08 11:39:01 localhost.localdomain systemd[1]: Started Super netcat tout fou.
Dec 08 11:58:09 localhost.localdomain nc[1343]: hello
Dec 08 11:58:10 localhost.localdomain nc[1343]: world
```

### Les logs de votre service

Une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
```
[chval@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep systemd
Dec 08 11:39:01 localhost.localdomain systemd[1]: Started Super netcat tout fou.
```

Une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
```
[chval@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep nc
Dec 08 11:58:09 localhost.localdomain nc[1343]: hello
Dec 08 11:58:10 localhost.localdomain nc[1343]: world
```

Une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service
```
[chval@localhost ~]$ sudo journalctl -xe -u tp2_nc | grep finished
░░ Subject: A start job for unit tp2_nc.service has finished successfull
```

En effet ça marche pu
```
[chval@localhost ~]$ nc 192.168.56.112 17959
Ncat: Connection refused.
```

### Affiner la définition du service

Je modifie le fichier du service et je recharge

```
[chval@localhost ~]$ sudo nano /etc/systemd/system/tp2_nc.service

[chval@localhost ~]$ sudo systemctl daemon-reload
```

Et voilà à quoi ressemble le fichier de config :

```
[chval@localhost ~]$ cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 17959
Restart=always
```

sucre