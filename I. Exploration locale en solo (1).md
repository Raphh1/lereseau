x# TP1 - Premier pas réseau





# I. Exploration locale en solo

## 1. Affichage d'informations sur la pile TCP/IP locale

### En ligne de commande

**🌞 Affichez les infos des cartes réseau de votre PC**
```
-  ipconfig /all

- Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 14-85-7F-7B-A8-31
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::1069:2710:7d3d:8fb4%14(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.16.212(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : 2 octobre 2022 23:58:09
   Bail expirant. . . . . . . . . . . . . : 3 octobre 2022 23:58:08
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 135562623
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-C2-A5-58-D8-BB-C1-79-C3-F0
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
   
- Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Realtek PCIe GbE Family Controller
   Adresse physique . . . . . . . . . . . : D8-BB-C1-79-C3-F0
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
```
**🌞 Affichez votre gateway**

ipconfig /all

-  Passerelle par défaut. . . . . . . . . : 10.33.19.254

**🌞 Déterminer la MAC de la passerelle**
```
- $ arp -a
- Interface : 10.33.16.212 --- 0xe
  Adresse Internet      Adresse physique      Type
  10.33.19.254          00-c0-e7-e0-04-4e     dynamique
  10.33.19.255          ff-ff-ff-ff-ff-ff     statique
  224.0.0.2             01-00-5e-00-00-02     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique
```
### En graphique (GUI : Graphical User Interface)

En utilisant l'interface graphique de votre OS :  

**🌞 Trouvez comment afficher les informations sur une carte IP (change selon l'OS)**

- ![](https://i.imgur.com/W6XQXBU.png)


## 2. Modifications des informations

### A. Modification d'adresse IP (part 1)  

🌞 Utilisez l'interface graphique de votre OS pour **changer d'adresse IP** :

- ![](https://i.imgur.com/JLCZ7ep.png)


---

## II. Exploration locale en duo

3. Modification d'adresse IP

    on a rentré tout les deux la meme adresse ip soit 10.10.10.127 mais cette     fois ci sur le port ethernet et pas la carte reseaux 

        Carte Ethernet Ethernet : 
         Adresse IPv4. . . . . . . . . . . . . .: 10.10.10.127(préféré)
 
 
       PS C:\Users\33603> ping 10.10.10.227
        Envoi d’une requête 'Ping'  10.10.10.227 avec 32 octets de données :
        Réponse de 10.10.10.127 : octets=32 temps<1ms TTL=128

      voila l'addresse mac  de mon partenaire 
         10.10.10.227          04-42-1a-89-b3-1a     dynamique

4. Utilisation d'un des deux comme gateway

        PS C:\Users\33603> ping 8.8.8.8

        Envoi d’une requête 'Ping'  8.8.8.8 avec 32 octets de données :
        Réponse de 8.8.8.8 : octets=32 temps=57 ms TTL=113

        PS C:\Users\33603> tracert 10.10.10.227

        Détermination de l’itinéraire vers PC-Samy [10.10.10.227]
        avec un maximum de 30 sauts :

          1     1 ms     1 ms     1 ms  PC-Samy [10.10.10.227]


sur le pc client 

    PS C:\Users\33603\Downloads\netcat-1.11> .\nc.exe 10.10.10.227 8888
    ping
    pong

sur le pc serveur 

    PS C:\Users\samyd\OneDrive\Bureau\netcat-win32-1.11\netcat-1.11> .\nc.exe -l -p 8888
    pong
    ping

pour verifier la connexion 

      PS C:\Windows\system32> netstat -a -n -b
      TCP    10.10.10.127:63479     10.10.10.227:8888      ESTABLISHED
      [nc.exe]

## 4. Utilisation d'un des deux comme gateway
---
🌞**Tester l'accès internet**

- pour tester la connectivité à internet on fait souvent des requêtes simples vers un serveur internet connu
- essayez de ping l'adresse IP `1.1.1.1`, c'est un serveur connu de CloudFlare (demandez-moi si vous comprenez pas trop la démarche)

🌞 **Prouver que la connexion Internet passe bien par l'autre PC**

- utiliser la commande `traceroute` ou `tracert` (suivant votre OS) pour bien voir que les requêtes passent par la passerelle choisie (l'autre le PC)

> La commande `traceroute` retourne la liste des machines par lesquelles passent le `ping` avant d'atteindre sa destination.

## 5. Petit chat privé

Here we go :

🌞 **sur le PC *serveur*** avec par exemple l'IP 192.168.1.1
- `nc.exe -l -p 8888`
  - "`netcat`, écoute sur le port numéro 8888 stp"
- il se passe rien ? Normal, faut attendre qu'un client se connecte

🌞 **sur le PC *client*** avec par exemple l'IP 192.168.1.2

- `nc.exe 192.168.1.1 8888`
  - "`netcat`, connecte toi au port 8888 de la machine 192.168.1.1 stp"
- une fois fait, vous pouvez taper des messages dans les deux sens
- appelez-moi quand ça marche ! :)
- si ça marche pas, essayez d'autres options de `netcat`

---

🌞 **Visualiser la connexion en cours**

- sur tous les OS, il existe une commande permettant de voir les connexions en cours
- ouvrez un deuxième terminal pendant une session `netcat`, et utilisez la commande correspondant à votre OS pour repérer la connexion `netcat` :

``
🌞 **Pour aller un peu plus loin**

- si vous faites un `netstat` sur le serveur AVANT que le client `netcat` se connecte, vous devriez observer que votre serveur `netcat` écoute sur toutes vos interfaces
  - c'est à dire qu'on peut s'y connecter depuis la wifi par exemple :D
- il est possible d'indiquer à `netcat` une interface précise sur laquelle écouter
  - par exemple, on écoute sur l'interface Ethernet, mais pas sur la WiFI


## 6. Firewall

Toujours par 2.

Le but est de configurer votre firewall plutôt que de le désactiver

🌞 **Activez et configurez votre firewall**

- autoriser les `ping`
  - configurer le firewall de votre OS pour accepter le `ping`
  - aidez vous d'internet
  - on rentrera dans l'explication dans un prochain cours mais sachez que `ping` envoie un message *ICMP de type 8* (demande d'ECHO) et reçoit un message *ICMP de type 0* (réponse d'écho) en retour
- autoriser le traffic sur le port qu'utilise `nc`
  - on parle bien d'ouverture de **port** TCP et/ou UDP
  - on ne parle **PAS** d'autoriser le programme `nc`
  - choisissez arbitrairement un port entre 1024 et 20000
  - vous utiliserez ce port pour communiquer avec `netcat` par groupe de 2 toujours
  - le firewall du *PC serveur* devra avoir un firewall activé et un `netcat` qui fonctionne
  
# III. Manipulations d'autres outils/protocoles côté client

## 1. DHCP

🌞**Exploration du DHCP, depuis votre PC**
```
- $ Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 14-85-7F-7B-A8-31
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::1069:2710:7d3d:8fb4%14(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.17.9(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : 5 octobre 2022 23:58:44
   Bail expirant. . . . . . . . . . . . . : 6 octobre 2022 23:58:46
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 135562623
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-C2-A5-58-D8-BB-C1-79-C3-F0
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```
## 2. DNS

🌞
```
$ Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 14-85-7F-7B-A8-31
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::1069:2710:7d3d:8fb4%14(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.17.9(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : 5 octobre 2022 23:58:44
   Bail expirant. . . . . . . . . . . . . : 6 octobre 2022 23:58:46
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 135562623
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-C2-A5-58-D8-BB-C1-79-C3-F0
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```
🌞
```
$ nslookup 8.8.8.8
Serveur :   dns.google
Address:  8.8.8.8

Nom :    dns.google
Address:  8.8.8.8
```



```
$ nslookup ynov.com
Serveur :   dns.google
Address:  8.8.8.8

Réponse ne faisant pas autorité :
Nom :    ynov.com
Addresses:  2606:4700:20::ac43:4ae2
          2606:4700:20::681a:ae9
          2606:4700:20::681a:be9
          172.67.74.226
          104.26.11.233
          104.26.10.233
```
          
```
$ nslookup google.com
Serveur :   dns.google
Address:  8.8.8.8

Réponse ne faisant pas autorité :
Nom :    google.com
Addresses:  2a00:1450:4007:80e::200e
          216.58.209.238
```

- l'adresse IP est donc 8.8.8.8

```
  nslookup 78.73.21.21
Serveur :   dns.google
Address:  8.8.8.8

Nom :    78-73-21-21-no168.tbcn.telia.com
Address:  78.73.21.21
```
```
 nslookup 22.146.54.58
Serveur :   dns.google
Address:  8.8.8.8

*** dns.google ne parvient pas à trouver 22.146.54.58 : Non-existent domain

  - *si vous vous demandez, j'ai pris des adresses random :)*
```

# IV. Wireshark

**Wireshark est un outil qui permet de visualiser toutes les trames qui sortent et entrent d'une carte réseau.**

On appelle ça un **sniffer**, ou **analyseur de trames.**

![Wireshark](./pics/wireshark.jpg)

Il peut :

- enregistrer le trafic réseau, pour l'analyser plus tard
- afficher le trafic réseau en temps réel

**On peut TOUT voir.**

Un peu austère aux premiers abords, une manipulation très basique permet d'avoir une très bonne compréhension de ce qu'il se passe réellement.

➜ **[Téléchargez l'outil Wireshark](https://www.wireshark.org/).**

🌞 Utilisez le pour observer les trames qui circulent entre vos deux carte Ethernet. Mettez en évidence :-1: 
ping passerelle
![](https://i.imgur.com/UMT88JF.png)

netcat
- ![](https://i.imgur.com/tyiOIjC.png)

DNS

- ![](https://i.imgur.com/amOGuvD.png)


# Bilan

**Vu pendant le TP :**

- visualisation de vos interfaces réseau (en GUI et en CLI)
- extraction des informations IP
  - adresse IP et masque
  - calcul autour de IP : adresse de réseau, etc.
- connaissances autour de/aperçu de :
  - un outil de diagnostic simple : `ping`
  - un outil de scan réseau : `nmap`
  - un outil qui permet d'établir des connexions "simples" (on y reviendra) : `netcat`
  - un outil pour faire des requêtes DNS : `nslookup` ou `dig`
  - un outil d'analyse de trafic : `wireshark`
- manipulation simple de vos firewalls

**Conclusion :**

- Pour permettre à un ordinateur d'être connecté en réseau, il lui faut **une liaison physique** (par câble ou par *WiFi*).  
- Pour réceptionner ce lien physique, l'ordinateur a besoin d'**une carte réseau**. La carte réseau porte une adresse MAC  
- **Pour être membre d'un réseau particulier, une carte réseau peut porter une adresse IP.**
Si deux ordinateurs reliés physiquement possèdent une adresse IP dans le même réseau, alors ils peuvent communiquer.  
- **Un ordintateur qui possède plusieurs cartes réseau** peut réceptionner du trafic sur l'une d'entre elles, et le balancer sur l'autre, servant ainsi de "pivot". Cet ordinateur **est appelé routeur**.
- Il existe dans la plupart des réseaux, certains équipements ayant un rôle particulier :
  - un équipement appelé *passerelle*. C'est un routeur, et il nous permet de sortir du réseau actuel, pour en joindre un autre, comme Internet par exemple
  - un équipement qui agit comme **serveur DNS** : il nous permet de connaître les IP derrière des noms de domaine
  - un équipement qui agit comme **serveur DHCP** : il donne automatiquement des IP aux clients qui rejoigne le réseau
  - **chez vous, c'est votre Box qui fait les trois :)**
