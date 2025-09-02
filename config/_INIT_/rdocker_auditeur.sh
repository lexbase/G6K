#!/bin/bash

#################################################################
# Variables                                                     #
#################################################################

settz="sudo timedatectl set-timezone Europe/Paris"
reconftz="sudo dpkg-reconfigure --frontend noninteractive tzdata"
hostname=$(hostname -i 2>&1)

load_image_php82="sudo docker load --input /var/hdcm-paris/docker/images/socle_front_php82"
load_image_php74="sudo docker load --input /var/hdcm-paris/docker/images/socle_front_php74"

gitpull="git -C /home/ubuntu/newGA pull ; git -C /home/ubuntu/Lexbase stash ; git -C /home/ubuntu/Lexbase pull ; git -C /home/ubuntu/lxb-layouts pull ;"
docker_stop_auditeur="sudo docker stop auditeur ; sudo docker rm auditeur ;"
clear_cache="sudo rm -rf /home/ubuntu/Lexbase/var/cache/dev/* ; sudo rm -rf /home/ubuntu/Lexbase/var/cache/prod/* ;"
docker_compose_up="sudo HOSTADDR=$hostname docker-compose -f /home/ubuntu/Lexbase/docker-compose-auditeur.yaml up -d --build"

#################################################################
# Go                                                            #
#################################################################

$settz
$reconftz

date

echo $gitpull
eval "$gitpull"

if [ "$(sudo docker images -q socle-front:php82 2> /dev/null)" = "" ]; then

    echo ">>> Loading image..."
    echo $load_image_php82
    eval "$load_image_php82"

fi

if [ "$(sudo docker images -q socle-front:php74 2> /dev/null)" = "" ]; then

    echo ">>> Loading image..."
    echo $load_image_php74
    eval "$load_image_php74"

fi

echo $docker_stop_auditeur
eval "$docker_stop_auditeur"

echo $clear_cache
eval "$clear_cache"

echo $docker_compose_up
eval "$docker_compose_up"

echo "Done"
