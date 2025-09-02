#!/bin/bash

#################################################################
# Variables                                                     #
#################################################################

INSTANCE_ID=$(curl -s -S http://169.254.169.254/latest/meta-data/instance-id)
LEXBASEV3_DIR="/home/ubuntu/Lexbase"
CD_LXB="cd $LEXBASEV3_DIR"

GET_BRANCHE_API=$(aws ec2 describe-instances --filter Name=instance-id,Values=$INSTANCE_ID --region eu-west-3 --query 'Reservations[].Instances[].Tags[?Key==`GitCheckout`].Value' --output text)
GET_DOCKER_SOCLE=$(aws ec2 describe-instances --filter Name=instance-id,Values=$INSTANCE_ID --region eu-west-3 --query 'Reservations[].Instances[].Tags[?Key==`SocleDocker`].Value' --output text)

if [ -z "${GET_BRANCHE_API}" ]; then
    BRANCHE_API=`cat $LEXBASEV3_DIR/VERSION.txt`
else
    BRANCHE_API="${GET_BRANCHE_API}"
fi

echo $BRANCHE_API

if [ -z "${GET_DOCKER_SOCLE}" ]; then
    DOCKER_SOCLE="socle-front:php82"
    DOCKER_SOCLE_FILENAME="socle_front_php82"
else
    DOCKER_SOCLE="${GET_DOCKER_SOCLE}"
    DOCKER_SOCLE_FILENAME="${GET_DOCKER_SOCLE}"
fi

echo $DOCKER_SOCLE
echo $DOCKER_SOCLE_FILENAME

docker_stop="sudo docker stop lexbase_fr"
docker_rm="sudo docker rm lexbase_fr"
git_stash="git -C $LEXBASEV3_DIR stash"
git_pull="git -C $LEXBASEV3_DIR pull"
git_checkout_master="git -C $LEXBASEV3_DIR checkout master"
git_checkout_branch="git -C $LEXBASEV3_DIR checkout $BRANCHE_API"
load_image_php82="sudo docker load --input /var/hdcm-paris/docker/images/$DOCKER_SOCLE_FILENAME"

copy_crontab="sudo cp $LEXBASEV3_DIR/config/_INIT_/docker_crontab.txt $LEXBASEV3_DIR/config/_INIT_/crontab_jobs_ubuntu.txt"
set_crontab="crontab $LEXBASEV3_DIR/config/_INIT_/crontab_jobs_ubuntu.txt"

settz="sudo timedatectl set-timezone Europe/Paris"
reconftz="sudo dpkg-reconfigure --frontend noninteractive tzdata"
hostname=$(hostname -i 2>&1)
$settz
$reconftz
$hostname

docker_compose_up="sudo HOSTADDR=$hostname docker-compose -f ${LEXBASEV3_DIR}/docker-compose.yaml up -d --build"

#################################################################
# Go                                                            #
#################################################################

date

if [ "$(sudo docker images -q $DOCKER_SOCLE 2> /dev/null)" = "" ]; then

    echo ">>> Loading image..."
    echo $load_image_php82
    eval "$load_image_php82"

fi

$CD_LXB

echo $git_checkout_master
$git_checkout_master

echo $git_stash
$git_stash

echo $git_pull
$git_pull

echo $git_checkout_branch
$git_checkout_branch

echo $git_stash
$git_stash

echo $git_pull
$git_pull

echo $docker_stop
$docker_stop

echo $docker_rm
$docker_rm

echo $docker_compose_up
$docker_compose_up

echo $copy_crontab
$copy_crontab

echo $set_crontab
$set_crontab
