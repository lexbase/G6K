#!/bin/bash

#################################################################
# Variables                                                     #
#################################################################

settz="sudo timedatectl set-timezone Europe/Paris"
reconftz="sudo dpkg-reconfigure --frontend noninteractive tzdata"
hostname=$(hostname -i 2>&1)

load_image_php82="sudo docker load --input /var/hdcm-paris/docker/images/socle_front_php82"
load_image_php74="sudo docker load --input /var/hdcm-paris/docker/images/socle_front_php74"

gitpull_GA="git -C /home/ubuntu/newGA pull"
gitstash_Lexbase="git -C /home/ubuntu/Lexbase stash"
gitpull_Lexbase="git -C /home/ubuntu/Lexbase pull"
gitpull_Lexbase_output=$(git -C /home/ubuntu/Lexbase pull 2>&1)
docker_stop_Auditeur="sudo docker stop auditeur"
docker_rm_Auditeur="sudo docker rm auditeur"
clearCache1="sudo rm -rf /home/ubuntu/Lexbase/var/cache/dev/*"
clearCache2="sudo rm -rf /home/ubuntu/Lexbase/var/cache/prod/*"
docker_compose_up="sudo HOSTADDR=$hostname docker-compose -f /home/ubuntu/Lexbase/docker-compose-auditeur.yaml up -d --build"

#################################################################
# Go                                                            #
#################################################################

$settz
$reconftz

date

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

echo $gitpull_GA
$gitpull_GA

echo $gitstash_Lexbase
$gitstash_Lexbase

echo $gitpull_Lexbase
$gitpull_Lexbase

echo "Hey ! What's up Lexbase-git-repository ?"
echo $gitpull_Lexbase_output

if [ "$gitpull_Lexbase_output" != "Already up to date." ]; then

    echo "We could use the rdocker thing... Go !"

    echo $docker_stop_Auditeur
    $docker_stop_Auditeur

    echo $docker_rm_Auditeur
    $docker_rm_Auditeur

    echo $clearCache1
    $clearCache1

    echo $clearCache2
    $clearCache2

    echo $docker_compose_up
    $docker_compose_up

    echo "Rdocker ended ! If you read this, please type 'lsd' or check auditeur.lexbase.fr"

fi

echo "Done"