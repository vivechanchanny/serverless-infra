# Creating a Bastion host on AWS
This page contains instructions to create a bastion host in AWS.

## Concept
Bastion hosts (also called “jump servers”) are often used as a best practice for accessing privately accessible hosts within a system environment. For example, your system might include an application host that is not intended to be publicly accessible. To access it for product updates or managing system patches, you typically log in to a bastion host and then access (or “jump to”) the application host from there. 
Access to the bastion host is ideally restricted to a specific IP range, typically from your organization’s corporate network or IP assigned to your home router by ISP. The benefit of using a bastion host in this regard is that access to any of the internal hosts is isolated to one means of access: through either a single bastion host or a group. For further isolation, the bastion host generally resides in a separate VPC.

## Goals
1. Only Bastion host is accessible from internet via SSH
  - This should be improved further to allow access only to only known IP's which could be dynamically changing depending on where you connect from.
  - Automatically configure the bastion security group allowed source IP's with the IP you are using to connect after 2FA check. https://aws.amazon.com/blogs/startups/securing-ssh-to-amazon-ec2-linux-hosts/
  - All other servers must be internal and SSH access should be limited to Bastion host.
2. Configure Mobaxterm to be able to access other internal hosts via Bastion
  - Edit Session->Network Settings->
  - Remote Host=internal host ip, username internal host username. In connect through ssh gateway use bastion settings


# Create Bastion instance
## Create AWS Linux2 Instance using this as cloud init
- https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/cloud-init.sh
> If you forgot to create the instance with user-data you can wget this file and execute it
## Configure Bastion
### Configure programatic access
We would be launching insstances using this bastion host. So enable programatic access from Bastion host. There are two possible options
- Assign a role to bastion host
- Run aws configure and keep the access key on bastion host(less secure)
#### Assign role to bastion host
Select the bastion host instance. Actions/Security/Modify IAM role and create a new administrative role to the bastion host.
#### aws configure
- Create a non root user in IAM( since root account must not be used for programatic access). Assign AdministratorAccess privilege to the user( Ideally only limited privilege must be given)
- Login as that IAM user. "Create access key" and download from here https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials
- Run "aws configure" on bastion host.
  - AWS Access Key ID [None]: 
  - AWS Secret Access Key [None]: 
  - Default region name [None]: us-east-1
### Configure SSH keys
> Note: EC2 Instance connect is a better apporach than this. However instance connect as of today works only on Amazon Linux and ubuntu. 
SSH access to all other hosts should go through Bastion. The private key to login to other hosts should be kept only on Bastion. While creating the instances use this key name bastion-to-other-hosts-key.
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/utils/create-ssh-key.sh -O create-ssh-key.sh
- bash create-ssh-key.sh
- For backup purpose download bastion-to-other-hosts-key.pem from bastion to your laptop and safestore it securely.

### Create security group and attach to bastion instance
In future when new instances are created allow network access to it from this security group "outgoing-from-bastion-secgrp".
- Login to bastion as ec2-user
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/create_and_assign_secgrp.sh -O create_and_assign_secgrp.sh
- Create a security group by name outgoing-from-bastion-secgrp and attach it to bastion instance
  - bash create_and_assign_secgrp.sh outgoing-from-bastion-secgrp


### Configure public IP
It is recommended to reserve an elastic IP in AWS and assign it to bastion host. This will help so that you don't need to change IP each time you restart Bastion. You can configure your domain and mobaxterm with this static IP you own.

# HAProxy
Ideally bastion host must be hardened and must not run any additional software. To save on cost(static IP and instance) I run load balancer on bastion. But below instructions can be run on any other instance that you plan to run the load balancer on.
- create and assign a security group 
  - wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/loadbalancer-cf.yml -O loadbalancer-cf.yml
  - aws cloudformation create-stack --stack-name loadbalancer-stack --template-body file://loadbalancer-cf.yml  --parameters ParameterKey=MySecurityGroup,ParameterValue=outgoing-from-loadbalancer-secgrp
  - wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/assign_secgrp.sh -O assign_secgrp.sh
  - bash assign_secgrp.sh outgoing-from-loadbalancer-secgrp
  - sleep 5 && aws cloudformation delete-stack --stack-name loadbalancer-stack
- Install haproxy
  - sudo wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/install_haproxy.sh -O install_haproxy.sh
  - bash install_haproxy.sh
- You need a backend to test your haproxy. Install LAMP following the instructions in https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/lamp
- update the /etc/haproxy/haproxy.cfg by changing all occurrences of apacheserver.local with with the private IP address of the lamp instance.
- systemctl restart haproxy
- systemctl enable haproxy
### Configure TLS
Below instructions were derived from [this documentation](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-centos-7)
- Update **yourdomain** to point the public IP of the host on which haproxy is running. If you don't have a domain [register a new one](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html)
It is recommended to an [elastic IP](https://console.aws.amazon.com/vpc/home?region=us-east-1#Addresses:) in AWS and assign it to haproxy host.
- Follow the below steps to generate new certs in /etc/haproxy/certs
  - wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/get-cert-letsencrypt.sh
  - bash get-cert-letsencrypt.sh **yourdomain**
  - At the prompts enter the following
    - (Enter 'c' to cancel): ***youremailaddress***
    - (A)gree/(C)ancel: ***Y***
    - (Y)es/(N)o: Y
- Modify /etc/haproxy/haproxy.cfg or /etc/hosts to point to the right backend on 443 and 80
- sudo systemctl restart haproxy
- run sudo systemctl status haproxy -l to make sure there was no error starting haproxy.
- Make sure your backend apache server is running and open https://yourdomain and https://yourdomain/phpMyAdmin in your browzer to test it.

> Note of thanks. This README.md was edited using   
