# Welcome to LAMP on AWS!

The examples in this folder contains instructions to quickly [install LAMP stack on AWS Linux 2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html) and configure TLS. 

## Prep steps
- Make sure bastion host is configured properly https://github.com/vivechanchanny/wordpress-serverlesss/blob/main/bastion/README.md#configure-bastion
  - for programmatic access
  - ssh key based login to other hosts.
  - security group to allow login to other hosts.
- You can also verify that your keypair is present here https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:

# Install & configure
Either use the fully automated approach or manually execute the commands
## Automated Approach
- Login to bastion host and set the following env variables.
  - export MYSQLROOTPASSWORD=CHANGEME_PASSWORD
  - export ANSIBLE_HOST_KEY_CHECKING=false
  - export LAMPINSTNAME=lampinst1
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/ansible-setup.yml -O ansible-setup.yml
- ansible-playbook -e  "mysql_root_password=$MYSQLROOTPASSWORD LAMPINSTNAME=$LAMPINSTNAME"  ansible-setup.yml
- export LAMP_INST_IP=$(bash get-private-ip.sh $LAMPINSTNAME)
- curl http://$LAMP_INST_IP:80
- update the /etc/haproxy/haproxy.cfg on load balancer host to point to this IP "echo $LAMP_INST_IP"
- sudo systemctl restart haproxy
- to test haproxy is configured properly run curl http://localhost:80
- (optional step) Temporarily allow access from internet to the this instance and access phpAdmin page http://publicip/phpMyAdmin/ and make sure you can login as root.

## Manual Approach
Use these steps if you prefer not to use the fully automated approach.

## Either create using CLI or manually on the UI.
### Create AWS Linux2 Instance using CLI
Create  instance
- Login to bastion host
- Set environment varaible to the SSH key name used to SSH from bastion
  - export MYSSHKEYNAME=bastion-to-other-hosts-key
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/create-instance.sh -O create-instance.sh
- bash create-instance.sh
### Create AWS Linux2 Instance using GUI
- Create Instance on UI with 
  - SSH key name used to SSH from bastion
  - with this link as userdata https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/cloud-init.sh
> If you forgot to create the instance with user-data you can wget this file and execute it

###  Allow access to bastion and loadbalancer
- Login to bastion host
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/utils/add-ingress-to-secgrp.sh -O add-ingress-to-secgrp.sh
- bash add-ingress-to-secgrp.sh lamp-secgrp outgoing-from-bastion-secgrp 22
- bash add-ingress-to-secgrp.sh lamp-secgrp outgoing-from-loadbalancer-secgrp 80
- bash add-ingress-to-secgrp.sh lamp-secgrp outgoing-from-loadbalancer-secgrp 443


###  Cloud init
This step is needed only if cloud-init is not run by providing as userinput while creating instance.
- Login to newly created host
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/cloud-init.sh -O cloud-init.sh
- bash cloud-init.sh
###  Configure Apache 
- Login to newly created host
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/configure-apache.sh -O configure-apache.sh
- bash configure-apache.sh
- curl http://localhost:80
###  Configure self signed TLS
| Note: Steps in this section will configure with a self signed TLS certificate. You will have to explicitly trust the certificate in browzer.
- curl https://localhost:443  should report "Connection refused" since TLS has not been configured.
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/configure-tls.sh -O configure-tls.sh
- bash configure-tls.sh
- curl https://localhost:443  should report self signed certificate error
- curl --insecure https://localhost:443
- For configuring a browzer trusted certificate use this procedure  https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/bastion#configure-tls for cert signed by  lets encrypt
###  Secure the database server
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/secure-db.sh -O secure-db.sh
- bash secure-db.sh
  - Enter current password for mysql root 

### Install  and configure phpMyAdmin
[phyMyAdmin](https://www.phpmyadmin.net/) is a web-based database management tool that you can use to view and edit the MySQL databases on your EC2 instance
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/lamp/phpAdmin-install-config.sh
- bash phpAdmin-install-config.sh
- access phpAdmin page http://yourdomain/phpMyAdmin/ and make sure you can login as root. TBD do not allow remote login to root
- http://yourdomain/phpMyAdmin/setup click on download to do any further configuration

