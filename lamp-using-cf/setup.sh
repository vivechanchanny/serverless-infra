sudo yum update -y aws-cfn-bootstrap
sudo yum install -y httpd
sudo yum install -y mysql-server
sudo yum install -y mysql-libs
sudo yum install -y php-mysql
sudo yum install -y mysql
sudo yum install -y php
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mysqld
sudo systemctl enable mysqld


