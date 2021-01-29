# LAMP stack using cloud formation
This page contains instructions to create lamp stack using cloud formation template
## Prep steps
- Make sure bastion host is configured properly https://github.com/vivechanchanny/wordpress-serverlesss/blob/main/bastion/README.md#configure-bastion
  - for programmatic access
  - ssh key based login to other hosts.
  - security group to allow login to other hosts.
- You can also verify that your keypair is present here https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:

###  Create AWS Linux2 Instance using cloud formation

- Login to Bastion host
- Set the following variables to approapriate values
  - export BASTION_SECURITY_GROUP=outgoing-from-bastion-secgrp
  - export DBRootPassword=Abcd1234 
  - export MYSSHKEYNAME=bastion-to-other-hosts-key
  - export DBPassword=Abcd1234

- rm -f cloud-formation.yml && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp-using-cf/cloud-formation.yml
- aws cloudformation validate-template --template-body file://cloud-formation.yml

###  Create instance 
- aws cloudformation delete-stack --stack-name  stackfromcli
- aws cloudformation create-stack   --stack-name stackfromcli --template-body  file://cloud-formation.yml --parameters  ParameterKey=DBPassword,ParameterValue=$DBPassword ParameterKey=DBRootPassword,ParameterValue=$DBRootPassword  ParameterKey=KeyName,ParameterValue=$MYSSHKEYNAME ParameterKey=SourceSSHSecurityGroupName,ParameterValue=$BASTION_SECURITY_GROUP

###  Configure LAMP 
- Find out the IP of the new instance created
- ssh ec2-user@newip
- Follow the instructions here to configure LAMP https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/lamp

