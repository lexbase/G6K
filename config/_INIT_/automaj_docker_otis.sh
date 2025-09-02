#!/bin/bash

#################################################################
# Variables                                                     #
#################################################################

settz="sudo timedatectl set-timezone Europe/Paris"
reconftz="sudo dpkg-reconfigure --frontend noninteractive tzdata"

gitpull_Lexbase="git -C /home/ubuntu/Lexbase pull"
gitpull_Lexbase_output=$(git -C /home/ubuntu/Lexbase pull 2>&1)
docker_stop_Auditeur="sudo docker stop otis"
docker_rm_Auditeur="sudo docker rm otis"
clearCache1="sudo rm -rf /home/ubuntu/Lexbase/var/cache/dev/*"
clearCache2="sudo rm -rf /home/ubuntu/Lexbase/var/cache/prod/*"
docker_compose_up="sudo docker-compose -f /home/ubuntu/Lexbase/docker-compose-otis.yaml up -d --build"

#################################################################
# Go                                                            #
#################################################################

$settz
$reconftz

date

echo $gitpull_Lexbase
$gitpull_Lexbase

echo "Hey ! What's up Lexbase-git-repository ?"
echo $gitpull_Lexbase_output


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

echo "Rdocker ended ! If you read this, please type 'lsd' or check otis.ilxb.fr"


echo "Done"