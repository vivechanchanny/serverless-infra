if [[ $1 == "" ]]
then
        echo "Usage $0 name-secgrp"
        exit 1
fi
aws ec2 create-security-group --description "video for access via bastion" --group-name $1 --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=$1}]" --query GroupId --output text
