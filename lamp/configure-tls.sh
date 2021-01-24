#! /bin/bash
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-amazon-linux-2.html
sudo systemctl is-enabled httpd
sudo systemctl start httpd && sudo systemctl enable httpd
sudo yum update -y

#mod_ssl is an optional module for the Apache HTTP Server. It provides strong cryptography
sudo yum install -y mod_ssl

cd /etc/pki/tls/certs

# generate a self-signed X.509 certificate and private key for your server host
sudo ./make-dummy-cert localhost.crt

# comment out  since localhost.crt contains both certificate and private key 
sudo sed -i 's/SSLCertificateKeyFile/#SSLCertificateKeyFile/' /etc/httpd/conf.d/ssl.conf

sudo systemctl restart httpd

