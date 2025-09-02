#!/bin/bash

echo ">>> BEGIN automaj.sh"

#################################################################
# Path vers Lexbase V3                                          #
#################################################################
V3_DIR="/var/www/LexbaseV3"

#################################################################
# Commandes                                                     #
#################################################################
remove_uploaded_pics="sudo rm -rf $V3_DIR/public/images/uploads/*"
remove_old_logs="sudo rm -rf $V3_DIR/var/log/*"
remove_cache_dev="sudo rm -rf $V3_DIR/var/cache/dev/*"
remove_cache_prod="sudo rm -rf $V3_DIR/var/cache/prod/*"
git_stash="git -C $V3_DIR stash"
git_pull="git -C $V3_DIR pull"
git_checkout_master="git -C $V3_DIR checkout master"
copy_apache="sudo cp $V3_DIR/config/_INIT_/apache.conf /etc/apache2/sites-available/000-default.conf"
maj_crontab="sudo crontab $V3_DIR/config/_INIT_/crontab.txt"
restart_apache="sudo /etc/init.d/apache2 restart"
composer_install="composer install --working-dir=$V3_DIR"
composer_autoload="composer dump-autoload --classmap-authoritative --working-dir=$V3_DIR"

#################################################################
# Lancement des scripts pour la branche MASTER                  #
#################################################################

echo $git_checkout_master
$git_checkout_master

echo $git_stash
$git_stash

echo $git_pull
$git_pull

#################################################################
# Nom de la branche qui sera pullée                             #
#################################################################
BRANCHE_API=`cat $V3_DIR/VERSION.txt`
git_checkout_branch="git -C $V3_DIR checkout $BRANCHE_API"

echo $git_checkout_branch
$git_checkout_branch

echo $git_stash
$git_stash

echo $git_pull
$git_pull

echo $remove_uploaded_pics
$remove_uploaded_pics

echo $remove_old_logs
$remove_old_logs

echo $remove_cache_dev
$remove_cache_dev

echo $remove_cache_prod
$remove_cache_prod

echo $copy_apache
$copy_apache

echo $maj_crontab
$maj_crontab

echo $composer_install
$composer_install

echo $composer_autoload
$composer_autoload

echo $restart_apache
$restart_apache

echo "<<< END automaj.sh"

