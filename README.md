# jeedomssl
/!\ Ne fonctionne plus
/!\ No longer working


English below

FRENCH : 

Il s'agit d'un script pour ajouter let's encrypt sur votre installation jeedom sous apache uniquement (pas sur nginx).
Tester sur debian 9,10.
Il faut exécuter le script en root.

## Utilisation  : 
``` bash jeedomssl.sh jeedom.youdomain.co youaddress@email.mail```
A exécuter en root 

## Le script fait ceci (dans l'ordre): 
* Vérifie que la commande lancée (bash jeedomssl.sh jeedom.ledomaine.fr  votremail@mail.com)
* Installation outils net-tools et dnsutils, certbot
* Vérifie que le domaine pointe bien vers l'ip de votre modem
* Vérifie que http est bien en écoute sur le port 80
* ajoute le mod ssl
* reload apache
* installation de certbot-auto
* Création des dossiers pour certbot
* Création des certificats SSL
* Création du vhost SSL
* Ajoute une cron pour le renew du certificat
* Vérifie la configuration apache

## Prérequis 
Votre box jeedom doit avoir un accès internet ainsi que les ports 80 et 443 NATé depuis votre modem vers votre box jeedom.
Pour naté les ports : 

[Sur livebox :](https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/configurer-des-regles-nat-pat/livebox-2-configurer-les-regles-nat-pour-l-utilisation-d-un-jeu-ou-d-une-application-serveur_18998-19118)

[Sur Box SFR NB6 :](https://assistance.sfr.fr/internet-et-box/box-nb6/heberger-site-box.html)

[Sur Freebox V6 :](https://www.cartelectronic.fr/blog/?p=2167)

[Sur Freebox mini 4K :](http://supertos.free.fr/supertos.php?page=1688)

[Sur Freeboc V5/Crystal :](http://supertos.free.fr/supertos.php?page=1686)

Pour une plus grande efficacité, merci de ne pas utiliser les domaines freeboxos, synology.me etc.. vous pouvez vous procurer un domaine .ovh pour 1,19 € TTC la première année puis 3,59 € TTC pour une année suivante.[ICI](https://www.ovh.com/fr/domaines/dotovh.xml)

ENGLISH  : 

Its a script for adding let's encrypt certificat in your DIY Jeedom on apache not in nginx.

Tested with debian 9 after fresh install.


## How to : 
``` bash jeedomssl.sh jeedom.youdomain.co youaddress@email.mail```
Execute on root user

* Check that the command launched (bash jeedomssl.sh jeedom.ledomaine.fr youremail@mail.com)
* Install tools net-tools and dnsutils
* Check if the domain is pointing to your ip 
* Check that http is listening on port 80
* add ssl mod
* reload apache
* certbot-auto installation
* Creating folders for certbot-auto
* Creating SSL Certificate
* Creation vhost SSL
* Adds a cron for the certificate renew
* Check apache configuration

## Prerequisites
Your jeedom box must have internet access as well as ports 80 and 443 NAT from your modem to your jeedom box. 

For greater efficiency, please do not use freeboxos domains, synology.me etc... you can get a domain .ovh for 1.19 € TTC the first year then 3.59 € TTC for a following year.[HERE](https://www.ovh.com/fr/domaines/dotovh.xml)


See you
w4zu.
