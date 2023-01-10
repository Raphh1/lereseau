# TP LINUX 1

## FEU

pour la première VM j'ai créé dans l'index un dossier "destrcution", dans ce dossier j'y ai mis d'autres dossier qui etaient present du type "sys", "etc" et au milieu de mon processus
plus aucune commande n'a fonctionné. Que ça soit "ls","cd" plus rien.

Pour la deuxième VM je suis pas allé très loin, j'ai supprimé le ficiher "lib64", je ne pouvais plus rien faire a part changer de fichier. En relançant la machine il m'a affiché des messages d'erreurs et ne s'est meme pas lancé.

Pour la troisième VM je suis allé dans le dossier boot et dans boot je suis allé dans Grub2, dans Grub2 j'ai supprimé des fichiers avec marqué Grub et en relançant ça m'a lancé dans 
un menu avec juste marqué Grub et avec aucune utilisation possible de l'OS.

Pour la quatrième VM, j'ai décidé d'aller explorer le dossier dev, dans le dossier dev se trouve sda qui represente les partitions de ma VM, en utilisant la commande "fdisk" j'ai pu supprimer de ma table de partition les deux partitions de ma VM ce qui fait que en relançant il ne trouve aucune des deux