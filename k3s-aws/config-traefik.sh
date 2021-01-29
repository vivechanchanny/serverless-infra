
#! /bin/bash
if [[ $MYDOMAIN == "" ]]
then
        echo "Set env MYDOMAIN to you kubernetes cluster domain"
        exit 1
fi
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./$MYDOMAIN.key -out ./$MYDOMAIN.cert -subj "/C=US/ST=New Sweden/L=Stockholm/O=none/OU=none/CN=$MYDOMAIN/emailAddress=test@$MYDOMAIN"


export MYDOMAIN_PUBLIC_CERT=$(base64 -w 0 ./$MYDOMAIN.cert)
export MYDOMAIN_PRIV_KEY=$(base64 -w 0 ./$MYDOMAIN.key)
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/traefik/traefik_helm_values.yaml -O traefik_helm_values.yaml
sed -i "s/CHANGEME_MYDOMAIN_PRIV_KEY/$MYDOMAIN_PRIV_KEY/g" traefik_helm_values.yaml
sed -i "s/CHANGEME_MYDOMAIN_PUBLIC_CERT/$MYDOMAIN_PUBLIC_CERT/g" traefik_helm_values.yaml
sed -i "s/CHANGEME_MYDOMAIN/$MYDOMAIN/g" traefik_helm_values.yaml

cat ./traefik_helm_values.yaml | sudo tee -a /var/lib/rancher/k3s/server/manifests/traefik.yaml

# cleanup . do not leave private keys at multiple places.
rm -f ./$MYDOMAIN.cert
rm -f ./$MYDOMAIN.key
rm -f ./traefik_helm_values.yaml
