# Create Bastion instance
## Create AWS Linux2 Instance using this as cloud init
- Initializing cloud-init for the instance
```
wget https://raw.githubusercontent.com/vivechanchanny/aws-archery/main/bastion/cloud-init.sh
bash cloud-init.sh
```
> If you forgot to create the instance with user-data you can wget this file and execute it
## Configure Bastion
### Configure programatic access
We would be launching insstances using this bastion host. So enable programatic access from Bastion host and remove it when you are done.
- Create a non root user in IAM( since root account must not be used for programatic access). Assign AdministratorAccess privilege to the user( Ideally only limited privilege must be given)
- Login as that IAM user. "Create access key" and download from here https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials
- Run aws configure on bastion host.
```
aws configure
```
  > AWS Access Key ID [None]: 
  > AWS Secret Access Key [None]: 
  > Default region name [None]: us-east-1
### Configure SSH keys
SSH access to all other hosts should go through Bastion. The private key to login to other hosts should be kept only on Bastion. While creating the instances use this key name.
- Login to bastion as ec2-user
- Creating keypair using CLI
```
aws ec2 create-key-pair --key-name bastion-to-other-hosts-key --query 'KeyMaterial' --output text > bastion-to-other-hosts-key.pem
```
- copy the private key you donwloaded on your laptop to bastion host.
```
cp bastion-to-other-hosts-key.pem /home/ec2-user/.ssh/id_rsa
chmod 0400 /home/ec2-user/.ssh/id_rsa
```
- For backup purpose download bastion-to-other-hosts-key.pem from bastion to your laptop and safestore it securely.
### Create security group and attach to bastion instance
In future when new instances are created allow network access to it from this security group "outgoing-from-bastion-secgrp".
- Login to bastion as ec2-user
- Create a security group by name bastion-outgoing-secgrp and attach it to bastion instance
```
wget https://raw.githubusercontent.com/vivechanchanny/aws-archery/main/bastion/CREATE-ASSIGN-BASTIONOUTGOING-SECGRG.sh -O create_and_assign_secgrp.sh
bash CREATE-ASSIGN-BASTIONOUTGOING-SECGRG.sh bastion-outgoing-secgrp
```
