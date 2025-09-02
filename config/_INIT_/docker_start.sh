#!/bin/bash

date

cd /var/www/g6k && composer dump-autoload --no-dev --classmap-authoritative && composer --ignore-platform-req=php install --no-interaction --prefer-dist && php bin/console assets:install
#cd /var/www/g6k && npm install --force && npm run build

chown -R www-data:www-data /var/www/g6k/var

#export GNUPGHOME=/home/ubuntu
#gpg --batch --import /var/tmp/lextract.asc
#gpg --batch --import /var/tmp/lextract.pub

#cp /var/tmp/lextract.* /home/ubuntu/

#chown -R www-data:www-data /home/ubuntu
#chmod 700 /home/ubuntu
#chmod 600 /home/ubuntu/*
#chmod 700 /home/ubuntu/*.d

echo $Envi

date

/usr/sbin/apache2ctl -D FOREGROUND
