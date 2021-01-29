#! /bin/bash 
echo Install the required dependencies.
sudo yum install php-mbstring -y

echo Restart Apache.
sudo systemctl restart httpd
echo Restart php-fpm.
sudo systemctl restart php-fpm

cd /var/www/html
echo latest phpMyAdmin release
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
[ -d phpMyAdmin ] || mkdir phpMyAdmin
tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz
sudo systemctl start mariadb
