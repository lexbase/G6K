#!/bin/sh

INSTANCE_ID=$(curl -s -S http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TAG_RDOCKER=$(aws ec2 describe-instances --region eu-west-3 --filter Name=instance-id,Values=$INSTANCE_ID --query 'Reservations[].Instances[].Tags[?Key==`rdocker`].Value' --output text)
REMOVE_TAG=$(aws ec2 delete-tags --region eu-west-3 --resources $INSTANCE_ID --tags Key=rdocker)

RDOCKER1="git -C /home/ubuntu/Lexbase stash"
RDOCKER2="git -C /home/ubuntu/Lexbase checkout master"
RDOCKER2bis="git -C /home/ubuntu/Lexbase pull"
RDOCKER3="sudo docker stop lexbase_fr"
RDOCKER4="sudo docker rm lexbase_fr"
RDOCKER5="sudo rm -rf /home/ubuntu/Lexbase/var/cache/dev/*"
RDOCKER6="sudo rm -rf /home/ubuntu/Lexbase/var/cache/prod/*"
RDOCKER7="sh /home/ubuntu/Lexbase/config/_INIT_/automaj_docker.sh"

if [ ! -z "$INSTANCE_TAG_RDOCKER" ]
then
	$REMOVE_TAG
    $RDOCKER1
    $RDOCKER2
    $RDOCKER2bis
    #$RDOCKER3
    #$RDOCKER4
    $RDOCKER5
    $RDOCKER6
    $RDOCKER7
    echo "Done"
fi