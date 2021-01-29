#! /bin/bash

#Add your user (in this case, ec2-user) to the apache group
sudo usermod -a -G apache ec2-user

# Change the group ownership of /var/www and its contents to the apache group
sudo chown -R ec2-user:apache /var/www
# change directory permissions
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
# add write permisions to files
find /var/www -type f -exec sudo chmod 0664 {} \;
