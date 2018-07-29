# jeedomssl


Its a script for adding let's encrypt certificat in your DIY Jeedom.

Tested with debian 9 after fresh install.


How to : 
``` bash jeedomssl.sh jeedom.youdomain.co youaddress@email.mail```


This script control if your external ip is used by your domain name, and look if your port 80 is listen by apache and open a 443 port in apache.
After create a vhost and certificat with certbot-auto and install auto renewal.

See you
w4zu.
