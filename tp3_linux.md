# TP 3 : We do a little scripting

# I. Script carte d'identité

## Rendu

Le fichier est [/srv/idcard/idcard.sh](files/idcard.sh).

Exemple d'exécution :
```
[chval@localhost idcard]$ ./idcard.sh 

Machine name: localhost
OS: Rocky Linux release 9.0 (Blue Onyx) and kernel version is #1 SMP PREEMPT Tue Sep 20 17:53:31 UTC 2022
IP: 10.0.2.15
RAM: 1113440 KB memory available on 1817688 KB total memory
Disk: 760284 KB space left
Top 5 processes by RAM usage :
- /home/chval/.cache/JetBrains/Fleet/artifacts/609.3/jbr/bin/java
- /usr/bin/python3
- /usr/sbin/NetworkManager
- /home/chval/.cache/JetBrains/Fleet/artifacts/1.11.116/fsdaemon/fsdaemon
- /usr/lib/systemd/systemd
Listening ports: 
- Netid
- udp
- udp
- tcp
- tcp
- tcp
- tcp
- tcp
Here is your random cat: ./cat.png
```

# II. Script youtube-dl

## Rendu

Le fichier est [/srv/yt/yt.sh](files/yt.sh).

Le fichier de log :
```
[chval@localhost yt]$ cat /var/log/yt/download.log 

[12/12/22 14:33:54] Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. File path : /srv/yt/downloads/tomato anxiety/tomato anxiety.mp4
[12/12/22 14:37:41] Video https://www.youtube.com/watch?v=dQw4w9WgXcQ was downloaded. File path : /srv/yt/downloads/Rick Astley - Never Gonna Give You Up (Official Music Video)/Rick Astley - Never Gonna Give You Up (Official Music Video).mp4
```

Exemple d'exécution :
```
./yt.sh <video_url>
```

```
[chval@localhost yt]$ ./yt.sh https://www.youtube.com/watch?v=dQw4w9WgXcQ

Video https://www.youtube.com/watch?v=dQw4w9WgXcQ was downloaded.
File path : /srv/yt/downloads/Rick Astley - Never Gonna Give You Up (Official Music Video)/Rick Astley - Never Gonna Give You Up (Official Music Video).mp4
```

# III. MAKE IT A SERVICE

## Rendu

Le fichier est [/srv/yt/yt-v2.sh](files/yt-v2.sh).
Le fichier de service est [ici (yt.service)](files/yt.service).
```
[Unit]
Description=Le giga service qui télécharge des films légalement

[Service]
ExecStart=/srv/yt/yt-v2.sh
User=yt

[Install]
WantedBy=multi-user.target
```

Le status du service :
```
[chval@localhost yt]$ systemctl status yt

● yt.service - Le giga service qui télécharge des films légalement
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-12-12 19:09:18 CET; 25min ago
   Main PID: 8254 (yt-v2.sh)
      Tasks: 2 (limit: 11118)
     Memory: 596.0K
        CPU: 7.789s
     CGroup: /system.slice/yt.service
             ├─8254 /bin/bash /srv/yt/yt-v2.sh
             └─8632 sleep 5

Dec 12 19:09:18 localhost.localdomain systemd[1]: Started Le giga service qui télécharge des films légalement.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: Video https://www.youtube.com/watch?v=s-GijOQP2p0 was downloaded.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: File path : /srv/yt/downloads/the printa (slow)/the printa (slow).mp4
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: Video https://www.youtube.com/watch?v=BXanQaSVQzg was downloaded.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: File path : /srv/yt/downloads/la vanne de l'hotel/la vanne de l'hotel.mp4
```

Le `journalctl` :
```
[chval@localhost yt]$ journalctl -xe -u yt

░░ 
░░ The unit yt.service completed and consumed the indicated resources.
Dec 12 19:09:18 localhost.localdomain systemd[1]: Started Le giga service qui télécharge des films légalement.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A start job for unit yt.service has finished successfully.
░░ 
░░ The job identifier is 2774.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: Video https://www.youtube.com/watch?v=s-GijOQP2p0 was downloaded.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: File path : /srv/yt/downloads/the printa (slow)/the printa (slow).mp4
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: Video https://www.youtube.com/watch?v=BXanQaSVQzg was downloaded.
Dec 12 19:09:33 localhost.localdomain yt-v2.sh[8265]: File path : /srv/yt/downloads/la vanne de l'hotel/la vanne de l'hotel.mp4
```