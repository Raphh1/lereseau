TP Réseau 4

# I. First steps

## Déterminez, pour ces 5 applications, si c'est du TCP ou de l'UDP

**Mon petit top d'applis**
+ Minecraft (Java)
+ Discord
+ Mon client pour mon serveur média perso (Jellyfin)
+ Windows Update
+ Thunderbird

| Nom de l'application | Protocole | IP et port du serveur distant | Port local ouvert |
|----------------------|-----------|--------------------------------|--------------------|
| Discord              | UDP (QUIC)| 162.159.135.232:443           | 57562 |
| Minecraft            | TCP       | 209.222.114.88:25565          | 51799 |
| Jellyfin             | TCP       | (IP de ma maison):8096        | 51892 |
| Windows Update       | TCP       | 8.250.143.254:80              | 51934 |
| Thunderbird (Mail)   | TCP (IMAP)| 64.233.166.109:993            | 51969 |

## Demandez l'avis à votre OS

+ Discord
```
[Discord.exe]
  UDP    0.0.0.0:60389          162.159.128.233:443
```
> Paquets de Discord [ici](pcaps/tp4_discord.pcapng).

+ Minecraft
```
[javaw.exe]
	TCP    10.33.17.11:54148      209.222.114.80:25565   ESTABLISHED
	TCP    10.33.17.11:61898      162.159.136.234:443    ESTABLISHED
```
> Paquets de Minecraft [ici](pcaps/tp4_minecraft.pcapng).

+ Jellyfin
```
[JellyfinMediaPlayer.exe]
  TCP    10.33.17.11:54201      x.x.x.x:8096     ESTABLISHED
```

+ Windows Update
```
// Il est pas affiché :(
```
> Paquets de Windows Update [ici](pcaps/tp4_wu.pcapng).

+ Thunderbird (Mail)
```
[thunderbird.exe]
  UDP    10.3.1.10:137          *:*
```
> Paquets de Thunderbird (bonus : j'envoi un mail) [ici](pcaps/tp4_mail.pcapng).

# II. Mise en place

## 1. SSH

### Examinez le trafic dans Wireshark & demandez aux OS
SSH utilise bien évidemment TCP (vérifié).

On peut voir la connexion SSH établie par `ssh.exe` depuis mon hôte :
```
[ssh.exe]
  TCP    127.0.0.1:6463         0.0.0.0:0              LISTENING
```

Et depuis la VM :
```
tcp     ESTAB  0        0                              10.4.1.11:ssh       10.4.1.1:53121
```

Paquets de la communication en SSH [ici](pcaps/tp4_ssh.pcapng).

## 2. Routage

...

# III. DNS

## 2. Setup

### Un `cat` des fichiers de conf

Config `/etc/named.conf` :
```
$ sudo cat /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
        listen-on port 53 { 127.0.0.1; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { localhost; };

        /*
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable
           recursion.
         - If your recursive DNS server has a public IP address, you MUST enable access
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface
        */
        recursion yes;

        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

# référence vers notre fichier de zone
zone "tp4.b1" IN {
     type master;
     file "tp4.b1.db";
     allow-update { none; };
     allow-query {any; };
};
# référence vers notre fichier de zone inverse
zone "1.4.10.in-addr.arpa" IN {
     type master;
     file "tp4.b1.rev";
     allow-update { none; };
     allow-query { any; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

Fichier de zone ``/var/named/tp4.b1.db`` :
```
$ sudo cat /var/named/tp4.b1.db
$TTL 86400
@ IN SOA dns-server.tp4.b1. admin.tp4.b1. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

; Infos sur le serveur DNS lui même (NS = NameServer)
@ IN NS dns-server.tp4.b1.

; Enregistrements DNS pour faire correspondre des noms à des IPs
dns-server IN A 10.4.1.201
node1      IN A 10.4.1.11
```

Fichier de zone inverse `/var/named/tp4.b1.rev` :
```
$ sudo cat /var/named/tp4.b1.rev
$TTL 86400
@ IN SOA dns-server.tp4.b1. admin.tp4.b1. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

; Infos sur le serveur DNS lui même (NS = NameServer)
@ IN NS dns-server.tp4.b1.

;Reverse lookup for Name Server
201 IN PTR dns-server.tp4.b1.
11 IN PTR node1.tp4.b1.
```

### Un `systemctl status named` qui prouve que le service tourne bien

```
$ systemctl status named
● named.service - Berkeley Internet Name Domain (DNS)
     Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2022-11-08 10:50:04 CET; 10min ago
   Main PID: 33630 (named)
      Tasks: 5 (limit: 11118)
     Memory: 19.1M
        CPU: 44ms
     CGroup: /system.slice/named.service
             └─33630 /usr/sbin/named -u named -c /etc/named.conf

Nov 08 10:50:04 localhost.localdomain named[33630]: network unreachable resolving './DNSKEY/IN': 2001:500:1::53#53
Nov 08 10:50:04 localhost.localdomain named[33630]: network unreachable resolving './NS/IN': 2001:500:1::53#53
Nov 08 10:50:04 localhost.localdomain named[33630]: zone localhost/IN: loaded serial 0
Nov 08 10:50:04 localhost.localdomain named[33630]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.>
Nov 08 10:50:04 localhost.localdomain named[33630]: zone localhost.localdomain/IN: loaded serial 0
Nov 08 10:50:04 localhost.localdomain named[33630]: all zones loaded
Nov 08 10:50:04 localhost.localdomain systemd[1]: Started Berkeley Internet Name Domain (DNS).
Nov 08 10:50:04 localhost.localdomain named[33630]: running
Nov 08 10:50:04 localhost.localdomain named[33630]: managed-keys-zone: Initializing automatic trust anchor management f>
Nov 08 10:50:04 localhost.localdomain named[33630]: resolver priming query complete
```

### Une commande `ss` qui prouve que le service écoute bien sur un port

```
$ ss -a -n
udp    UNCONN     0       0                                         127.0.0.1:53                  0.0.0.0:*           *
```

Il écoute le port **53**.

Je rajoute le port dans le pare-feu :
```
$ sudo firewall-cmd --add-port=53/udp --permanent
success
$ sudo firewall-cmd --add-port=53/tcp --permanent
success
```

## 3. Test

### Sur la VM

Résolution de `node1.tp4.b1` :
```
$ dig node1.tp4.b1

; <<>> DiG 9.16.23-RH <<>> node1.tp4.b1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 2644
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 839ca737cbb6bd4e01000000636a4ae1c1d4988778705f3a (good)
;; QUESTION SECTION:
;node1.tp4.b1.                  IN      A

;; ANSWER SECTION:
node1.tp4.b1.           86400   IN      A       10.4.1.11

;; Query time: 0 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Tue Nov 08 13:26:10 CET 2022
;; MSG SIZE  rcvd: 85
```

Résolution de `dns-server.tp4.b1` :
```
$ dig dns-server.tp4.b1

; <<>> DiG 9.16.23-RH <<>> dns-server.tp4.b1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10723
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: ab9b402c90fc8f5501000000636a4b21df2a1c41e94e46a7 (good)
;; QUESTION SECTION:
;dns-server.tp4.b1.             IN      A

;; ANSWER SECTION:
dns-server.tp4.b1.      86400   IN      A       10.4.1.201

;; Query time: 3 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Tue Nov 08 13:27:13 CET 2022
;; MSG SIZE  rcvd: 90
```

Mais aussi la résolution de `google.com` :
```
$ dig google.com

; <<>> DiG 9.16.23-RH <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55034
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: e1ddbc695f628a2901000000636a4b48e2c47bd283f8d598 (good)
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             173     IN      A       142.250.200.238

;; Query time: 0 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Tue Nov 08 13:27:52 CET 2022
;; MSG SIZE  rcvd: 83
```

### Sur le PC

```
> nslookup node1.tp4.b1 10.4.1.201
Serveur :   dns-server.tp4.b1
Address:  10.4.1.201

Nom :    node1.tp4.b1
Address:  10.4.1.11
```

Les paquets sont [ici](pcaps/tp4_dns.pcapng).