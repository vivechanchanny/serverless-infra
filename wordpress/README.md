# A secure wordpress installation on AWS

Below instructions are derived from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html

##
- setup the LAMP as specified in https://github.com/vivechanchanny/aws/tree/main/lamp
- login to LAMP
```
rm -f install-wordpress.sh && wget https://raw.githubusercontent.com/vivechanchanny/aws/main/wordpress/install-wordpress.sh
export MYSQL_ROOTPASSWORD=password
bash install-wordpress.sh
```
- visit http://server/wp-admin
- visit yourdomain in browzer and create the first wordpress administrator user to manage the wordpress website

