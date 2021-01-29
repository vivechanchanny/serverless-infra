curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644


# turn on dashboard for traefic loadbalancer
sudo sed "/valuesContent/a\    dashboard:\n      enabled: true\n      domain: \"$MYK3SDOMAIN\"" /var/lib/rancher/k3s/server/manifests/traefik.yaml

sleep 2
kubectl get endpoints traefik-dashboard -n kube-system

# Install Kubernetes Dashboard
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/alternative.yaml

