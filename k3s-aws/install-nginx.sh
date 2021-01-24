#! /bin/bash
if [[ $MYDOMAIN == "" ]]
then
        echo "Set env MYDOMAIN to you kubernetes cluster domain"
        exit 1
fi

wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/nginx/nginx-tls-secret.yaml -O nginx-tls-secret.yaml


openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./nginx_$MYDOMAIN.key -out ./nginx_$MYDOMAIN.cert -subj "/C=US/ST=New Sweden/L=Stockholm/O=none/OU=none/CN=nginx.$MYDOMAIN/emailAddress=test@$MYDOMAIN"
export MYDOMAIN_PUBLIC_CERT=$(base64 -w 0 ./nginx_$MYDOMAIN.cert)
export MYDOMAIN_PRIV_KEY=$(base64 -w 0 ./nginx_$MYDOMAIN.key)
sed -i "s/CHANGEME_MYDOMAIN_PRIV_KEY/$MYDOMAIN_PRIV_KEY/g" nginx-tls-secret.yaml
sed -i "s/CHANGEME_MYDOMAIN_PUBLIC_CERT/$MYDOMAIN_PUBLIC_CERT/g" nginx-tls-secret.yaml
sed -i "s/CHANGEME_MYDOMAIN/$MYDOMAIN/g" nginx-tls-secret.yaml

kubectl apply -f nginx-tls-secret.yaml

wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/nginx/nginx_deployment.yaml -O nginx_deployment.yaml
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/nginx/nginx_service.yaml -O nginx_service.yaml
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/nginx/nginx_ingress.yaml -O nginx_ingress.yaml
kubectl apply -f nginx_deployment.yaml
kubectl apply -f nginx_service.yaml
sed -i "s/CHANGEME_MYDOMAIN/$MYDOMAIN/g" nginx_ingress.yaml
kubectl apply -f nginx_ingress.yaml

