#!/bin/bash
#Usage bash jeedomssl.sh jeedom.domaine.fr monemail@pourletsencrypt.com 
# Scripted By w4zu
ssldir="/root/ssl/letsencrypt"
workdir="$ssldir/work"
configdir="$ssldir/etc"
logsdir="$ssldir/logs"
wellknown="$mydocroot/.well-known"
mydocroot="/var/www/html"
domaine="$1"
myvhost="/etc/apache2/sites-enabled/$1.ssl.conf"
admin_mail="$2"
#Check domaine
if [ -z "$domaine" ]
then 
    echo "il n'y a pas de domaine renseigné, bash jeedomssl.sh jeedom.domaine.fr monemail@pourletsencrypt.com"
    exit 1
else
    echo "ok"
fi
if [ -z "$admin_mail" ]
then 
    echo "il n'y a pas de mail renseigné, bash jeedomssl.sh jeedom.domaine.fr monemail@pourletsencrypt.com"
    exit 2
else
    echo "ok"
fi
#installation net-tool
apt install net-tools
apt install dnsutils
#Vérification correspondance IP/DOMAINE
dig $1 +short
echo "Merci de recopier l'ip ci-dessus"
read "diginfo"
curl ipinfo.io/ip
echo "Merci de recopier l'ip ci-dessus"
read "ipinfo"
if [ "$diginfo" != "$ipinfo" ]
then
    echo "il faut vérifier la correspondance entre votre domaine et votre ip"
    exit 3
else
    echo "ok"
fi
netstat -tlnpe | grep 80
echo $?
if [ "$?" -eq "1" ]
then
    echo "votre jeedom n'ecoute pas sur le port 80, c'est obligatoire pour la validation let's encrypt"
else
    echo "ok"
fi
#Installation Certbot
a2enmod ssl
/etc/init.d/apache2 reload
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
mv certbot-auto /usr/local/bin/
/usr/local/bin/certbot-auto --noninteractive --os-packages-only
#Création_Vérification directory lets encrypt
if [ -d "$ssldir" ]
then 
	echo $ssldir
	echo "directory exist !"
else 
	/bin/mkdir -p $ssldir
fi
if [ -d "$workdir" ]
then 
	echo $workdir
	echo "directory exist !"
else 
	/bin/mkdir -p $workdir
fi
if [ -d "$configdir" ]
then 
	echo $configdir
	echo "directory exist !"
else 
	/bin/mkdir -p $configdir
fi
if [ -d "$logsdir" ]
then 
	echo $logsdir
	echo "directory exist !"
else 
	/bin/mkdir -p $logsdir
fi
if [ -d "$wellknown" ]
then 
    echo $wellknown
    echo "directory exist !"
else 
    /bin/mkdir -p $wellknown
    /bin/chown www-data:www-data $wellknown
fi
#Installation certificat 
if [ -d "$mydocroot" ]
then
/usr/local/bin/certbot-auto certonly --agree-tos --email=$admin_mail --work-dir=$workdir --logs-dir=$logsdir --config-dir=$configdir --webroot -w $mydocroot -d $domaine
else
    /bin/mkdir -p $mydocroot
    echo '<?php echo "generatedbyvhostgenerator"; ?>' >> $mydocroot/index.php
    /bin/chown www-data:www-data $mydocroot
    /usr/local/bin/certbot-auto certonly --agree-tos --email=$admin_mail --work-dir=$workdir --logs-dir=$logsdir --config-dir=$configdir --webroot -w $mydocroot -d $domaine
fi
sleep 2
#Creation Vhost
if [ -f "$myvhost" ]
then
    echo "vhost already exist ! bye"
    exit 3
else

/usr/bin/touch $myvhost

cat << EOF > $myvhost

<VirtualHost *:443>

    ServerAdmin postmaster@$1
    ServerName www.$1
    ServerAlias $1
    CustomLog /var/www/html/log/$1_access.ssl.log combined
    ErrorLog  /var/www/html/log/$1_error.ssl.log
    LogLevel warn

    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /root/ssl/letsencrypt/etc/live/$1/cert.pem
    SSLCertificateChainFile /root/ssl/letsencrypt/etc/live/$1/chain.pem
    SSLCertificateKeyFile /root/ssl/letsencrypt/etc/live/$1/privkey.pem

    <Directory "/var/www/html">
        Options FollowSymLinks MultiViews
        AllowOverride All
        Order deny,allow
        deny from all
        allow from all
    </Directory>

    ServerSignature Off

</VirtualHost>

EOF
/bin/chown www-data:www-data $myvhost

#Ajout certbot-auto renew dans crontab utilisateur
echo "0 0 * * 0 /usr/local/bin/certbot-auto renew --force-renewal" >> /etc/cron.d/certbot
/usr/sbin/apache2ctl configtest
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo "||||||||||||||||||||||||||||||||||||"
echo "Si Warning: ou Syntax Non OK ne pas redemarrer le service apache."
echo "Si Syntax OK uniquement vous pouvez redemarrer le service apache."
echo "pour redemarrer apache /etc/init.d/apache2 restart"
fi
