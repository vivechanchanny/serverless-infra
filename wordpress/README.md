# A secure wordpress installation on AWS

Below instructions are derived from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html

##
- setup the LAMP as specified in https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/lamp
- login to LAMP
- wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/wordpress/install-wordpress.sh -O install-wordpress.sh
- export MYSQL_ROOTPASSWORD=password
- bash install-wordpress.sh
- visit http://server/wp-admin/  Do not forget the trailing /
- visit yourdomain in browzer and create the first wordpress administrator user to manage the wordpress website
