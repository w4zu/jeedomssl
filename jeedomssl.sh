#!/bin/bash
# Usage bash jeedomssl.sh jeedom.domaine.fr monemail@pourletsencrypt.com 
# Scripted By w4zu
# Version : 0.5
# Twitter : https://twitter.com/w4zu
# Tested on Debian 9,10,11
# Also today debian 11 is not really good for jeedom.
#ssldir="/root/ssl/letsencrypt"
workdir="$ssldir/work"
configdir="$ssldir/etc"
logsdir="$ssldir/logs"
wellknown="$mydocroot/.well-known"
mydocroot="/var/www/html"
domaine="$1"
myvhost="/etc/apache2/sites-enabled/$1.ssl.conf"
admin_mail="$2"
croncertbot=/etc/cron.d/certbot
fichierdelog="/var/log/log_create_ssl.txt"
#Logging is only for debug
touch $fichierdelog
echo "------ `date -u` ---BEGIN---" >> $fichierdelog
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
#installation net-tool & certbot
sudo apt install net-tools dnsutils libwww-perl libapache2-mod-fcgid apache2 certbot python3-certbot-apache
#Verification of correspondence IP/DOMAINE
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
    exit 4
else
    echo "ok"
fi
a2enmod ssl
/etc/init.d/apache2 reload
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

if [ -f "$myvhost" ]
then
    echo "vhost already exist ! bye"
    exit 5
else

/usr/bin/touch $myvhost

cat << EOF > $myvhost
<VirtualHost *:80>
    ServerAdmin postmaster@$1
    ServerName $1
    CustomLog /var/www/html/log/$1_access.ssl.log combined
    ErrorLog  /var/www/html/log/$1_error.ssl.log
    LogLevel warn
    DocumentRoot /var/www/html
    <Directory "/var/www/html">
        Options FollowSymLinks MultiViews
        AllowOverride All
        Order deny,allow
        deny from all
        allow from all
    </Directory>
#       Include /etc/letsencrypt/options-ssl-apache.conf
    ServerSignature Off
</VirtualHost>
EOF
/bin/chown www-data:www-data $myvhost
service apache2 reload
#Installing certificate
if [ -d "$mydocroot" ]
then
#Uncomment if doesnt work#/usr/bin/certbot certonly --agree-tos --email=$admin_mail --work-dir=$workdir --logs-dir=$logsdir --config-dir=$configdir --webroot -w $mydocroot -d $domaine
     /usr/bin/certbot --agree-tos --email=$admin_mail -d $domaine --redirect
else
    /bin/mkdir -p $mydocroot
    echo '<?php echo "generatedbyvhostgenerator"; ?>' >> $mydocroot/index.php
    /bin/chown www-data:www-data $mydocroot
#Uncomment if doesnt work#/usr/bin/certbot certonly --agree-tos --email=$admin_mail --work-dir=$workdir --logs-dir=$logsdir --config-dir=$configdir --webroot -w $mydocroot -d $domaine
    /usr/bin/certbot --agree-tos --email=$admin_mail -d $domaine --redirect
fi
sleep 2
#Add crontab for certbot-auto
if [ -f "$croncertbot" ]
then 
    echo "crontab OK"
else
    echo "0 0 * * 0 /usr/bin/certbot -q renew" >> /etc/cron.d/certbot
fi
/usr/sbin/apache2ctl configtest
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo "||||||||||||||||||||||||||||||||||||"
echo "If Warning: or Syntax not OK do not restart the apache service."
echo "If Syntax OK only you can restart the apache service."
echo "If The SSLCertificateChainFile directive (ssl.conf) is deprecated IS NOT a problem"
echo "To restart apache /etc/init.d/apache2 restart"
fi
echo "Admin mail ? $admin_mail >> $fichierdelog
echo "Wellknow ? $wellknown >> $fichierdelog
echo "Domain name ? $domaine" >> $fichierdelog
echo "------ `date -u` ---END---" >> $fichierdelog
