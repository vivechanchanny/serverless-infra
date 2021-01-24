#!/bin/bash

#K3s provides an installation script that is a convenient way to install it as a service on systemd or openrc based systems. This script is available at https://get.k3s.io
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

kubectl get node
sudo kubectl cluster-info
sudo k3s ctr images list -q
