if [[ $REGISTRY_PASSWORD == "" ]]
then
        echo "Set env REGISTRY_PASSWORD to the password of the container registry that you will run on k3s"
        exit 1
fi
sudo apt install -y apache2-utils
htpasswd -bBc htpasswd1 registry $REGISTRY_PASSWORD
kubectl create secret generic docker-registry-htpasswd --from-file ./htpasswd
kubectl describe secret docker-registry-htpasswd


kubectl apply -f https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/registry_deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/registry_service.yaml
kubectl apply -f https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/registry_ingress.yaml


