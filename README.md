# jeedomssl

FRENCH : 

Il s'agit d'un script pour ajouter let's encrypt sur votre installation jeedom.
Tester sur debian9.
Il faut executer le script en root.

Utilisation  : 
``` bash jeedomssl.sh jeedom.youdomain.co youaddress@email.mail```

Le script fait ceci (dans l'ordre): 
Vérifie que la commande lancée (bash jeedomssl.sh jeedom.ledomaine.fr  votremail@mail.com)
Installation outils net-tools et dnsutils
Vérifie que le domaine pointe bien vers l'ip de votre modem
Vérifie que http est bien en écoute sur le port 80
ajoute le mod ssl
reload apache
installation de certbot-auto
Création des dossiers pour certbot
Création des certificats SSL
Création du vhost SSL
Ajoute une cron pour le renew du certificat
Vérifie la configuration apache



ENGLISH  : 

Its a script for adding let's encrypt certificat in your DIY Jeedom.

Tested with debian 9 after fresh install.


How to : 
``` bash jeedomssl.sh jeedom.youdomain.co youaddress@email.mail```

Check that the command launched (bash jeedomssl.sh jeedom.ledomaine.fr youremail@mail.com)
Install tools net-tools and dnsutils
Check if the domain is pointing to your ip 
Check that http is listening on port 80
add ssl mod
reload apache
certbot-auto installation
Creating folders for certbot-auto
Creating SSL Certificate
Creation vhost SSL
Adds a cron for the certificate renew
Check apache configuration


See you
w4zu.
