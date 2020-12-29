### Create an  ec2-instance
> https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html
### Configure public IP
It is recommended to reserve an elastic IP in AWS and assign it to bastion host. This will help so that you don't need to change IP each time you restart Bastion. You can configure your domain and mobaxterm with this static IP you own.
> https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
# Create Bastion instance
## Create AWS Linux2 Instance using this as cloud init
- Initializing cloud-init for the instance
```
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/cloud-init.sh
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
- Set the Respective credentials
   - AWS Access Key ID [None]: 
   - AWS Secret Access Key [None]: 
   - Default region name [None]: us-east-1
   - Default output format : press enter
### Configure SSH keys
SSH access to all other hosts should go through Bastion. The private key to login to other hosts should be kept only on Bastion. While creating the instances use this key name.
- Login to bastion as ec2-user
- Creating keypair using CLI
```
aws ec2 create-key-pair --key-name bastion-to-other-hosts-key --query 'KeyMaterial' --output text > bastion-to-other-hosts-key.pem
```
- copy the private key you donwloaded on your laptop to bastion host.
- sets permissions so that User / owner can read
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
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/CREATE-ASSIGN-BASTIONOUTGOING-SECGRG.sh -O CREATE-ASSIGN-BASTIONOUTGOING-SECGRG.sh
bash CREATE-ASSIGN-BASTIONOUTGOING-SECGRG.sh bastion-outgoing-secgrp
```
# HAProxy
Ideally bastion host must be hardened and must not run any additional software. To save on cost(static IP and instance) I run load balancer on bastion. But below instructions can be run on any other instance that you plan to run the load balancer on.
- create and assign a security group 
```
wget https://raw.githubusercontent.com/praveensiddu/aws/main/bastion/loadbalancer-cf.yml -O loadbalancer-cf.yml
aws cloudformation create-stack --stack-name loadbalancer-stack --template-body file://loadbalancer-cf.yml  --parameters ParameterKey=MySecurityGroup,ParameterValue=outgoing-from-loadbalancer-secgrp
wget https://raw.githubusercontent.com/praveensiddu/aws/main/bastion/assign_secgrp.sh -O assign_secgrp.sh
bash assign_secgrp.sh outgoing-from-loadbalancer-secgrp
sleep 5 && aws cloudformation delete-stack --stack-name loadbalancer-stack
```  
- Install haproxy
```
sudo wget https://raw.githubusercontent.com/praveensiddu/aws/main/bastion/install_haproxy.sh -O install_haproxy.sh
bash install_haproxy.sh
````  
- You need a backend to test your haproxy. Install LAMP following the instructions in https://github.com/praveensiddu/aws/tree/main/lamp
- update the /etc/haproxy/haproxy.cfg by changing all occurrences of apacheserver.local with with the private IP address of the lamp instance.
- After updating the private IP restart the haproxy
```
systemctl restart haproxy
systemctl enable haproxy
```
### Configure TLS
Below instructions were derived from [this documentation](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-centos-7)
- Update **yourdomain** to point the public IP of the host on which haproxy is running. If you don't have a domain [register a new one](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html)
It is recommended to an [elastic IP](https://console.aws.amazon.com/vpc/home?region=us-east-1#Addresses:) in AWS and assign it to haproxy host.
- Follow the below steps to generate new certs in /etc/haproxy/certs
```
  - wget https://raw.githubusercontent.com/praveensiddu/aws/main/bastion/get-cert-letsencrypt.sh
  - bash get-cert-letsencrypt.sh **yourdomain**
```  
- At the prompts enter the following
    - (Enter 'c' to cancel): ***youremailaddress***
    - (A)gree/(C)ancel: ***Y***
    - (Y)es/(N)o: Y
```
- sudo systemctl restart haproxy
```
- Make sure your backend apache server is running and open https://yourdomain and https://yourdomain/phpMyAdmin in your browzer to test it.
