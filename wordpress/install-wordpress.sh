
#Below instructions are derived from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html

if [[ "$MYSQL_ROOTPASSWORD" == "" ]]
then
        echo "Please set the environment variable MYSQL_ROOTPASSWORD"
        exit 1
fi

echo "Generate random password"
export wordpress_db_pass=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev| sed 's/[^a-zA-Z0-9]//g'`

echo downloading wordpress from https://wordpress.org/latest.tar.gz
/bin/rm -f latest.tar.gz && wget https://wordpress.org/latest.tar.gz
/bin/rm -rf wordpress
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php



wget https://api.wordpress.org/secret-key/1.1/salt/ -O salt.txt

export pattern=DB_NAME
export saltline="define('DB_NAME', 'wordpress-db');"
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern=DB_USER
export saltline="define('DB_USER', 'wordpress-user');"
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern=DB_PASSWORD
export saltline="define('DB_PASSWORD', '"$wordpress_db_pass"');"
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'AUTH_KEY'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'SECURE_AUTH_KEY'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'LOGGED_IN_KEY'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'NONCE_KEY'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'AUTH_SALT'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'SECURE_AUTH_SALT'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'LOGGED_IN_SALT'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php

export pattern="'NONCE_SALT'"
export saltline=`grep "$pattern" salt.txt`
sed -i "/$pattern/c\\$saltline" wordpress/wp-config.php


sudo systemctl start mariadb
/bin/rm -f wordpress-db.sql && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/wordpress/wordpress-db.sql
sed -i "s/your_strong_password/$wordpress_db_pass/g" wordpress-db.sql

# TBD remove the file since it contains password

mysql -u root --password=$MYSQL_ROOTPASSWORD < wordpress-db.sql

cp -r wordpress/* /var/www/html/

sed '/<Directory \"\/var\/www\/html\">/,/AllowOverride None/ {
s/AllowOverride None/AllowOverride All/
}' /etc/httpd/conf/httpd.conf

sudo yum install php-gd -y
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb
sudo systemctl status mariadb
sudo systemctl status httpd




 
