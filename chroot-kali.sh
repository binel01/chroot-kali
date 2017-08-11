#! /bin/bash

#########################################################################################
## Ce script permet de chrooter le système KALI LINUX dans n'importe quel OS Linux     ##
##                                                                                     ##
## Pour cela, on a besoin:                                                             ##
## 1- Le fichier /live/filesystem.squashfs situé dans le fichier ISO de KALI:          ##
##    Il contient tous les programmes préinstallés dans KALI                           ##
##                                                                                     ##
## 2- Le fichier casper-rw: qui permettra de persister les données obtenues par KALI   ##
##                                                                                     ##
#########################################################################################

# Création du fichier casper-rw de taille 1GO
dd if=/dev/zero of=casper-rw bs=1M  count=1024 

# Formatage du fichier en ext3
mkfs.ext3 -F casper-rw 

# Donner tous les droits d'accès au dossier /media
cd /media
sudo find . -type d -exec chmod 777 {} \;

# Il faut créer trois dossiers dans le dossier /media: rootfs, casper et kali
mkdir rootfs
mkdir casper
mkdir kali

# Ensuite il faut monter le fichier filesystem.squasfs en lecture seule sur rootfs
# et casper-rw en lecture et ecriture dans le dossier casper
sudo mount -o loop,rw /chemin_fichier_casper_rw /media/casper

sudo mount  -o loop,ro -t squashfs /chemin_fichier_squashfs /media/rootfs

# Ensuite on doit unir (unionfs) ces deux systèmes de fichiers
sudo mount -t aufs -o dirs=/media/casper=rw:/media/rootfs=ro unionfs /medi/kali

# On peut maintenant changer d'OS et accéder à KALI avec chroot
sudo chroot /medi/kali

# Pour vérifier, il suffit de taper: 
lsb_release -a



