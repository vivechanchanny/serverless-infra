#! /bin/bash
if [[ $MYDOMAIN == "" ]]
then
        echo "Set env MYDOMAIN to you kubernetes cluster domain"
        exit 1
fi

#instruction were derived from https://pgillich.medium.com/setup-lightweight-kubernetes-with-k3s-6a1c57d62217
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
wget https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/alternative.yaml -O alternative.yaml 
kubectl apply -f alternative.yaml 
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/dashboard/sa.yaml -O sa.yaml
kubectl apply -f sa.yaml
sleep 5
kubectl get endpoints kubernetes-dashboard -n kubernetes-dashboard
wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/k3s-aws/manifests/kubernetes-dashboard_ingress.yaml -O kubernetes-dashboard_ingress.yaml
sed -i "s/CHANGEME_MYDOMAIN/$MYDOMAIN/g"  kubernetes-dashboard_ingress.yaml
kubectl apply -f kubernetes-dashboard_ingress.yaml

