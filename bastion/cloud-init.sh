#!/bin/bash
sudo yum update -y
sudo yum install tree -y
sudo yum install docker -y
sudo yum install jq -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


sudo systemctl enable docker
sudo systemctl start docker

# install ansible for automation( ideally a dedicated orchestration host is recommended)
sudo amazon-linux-extras install -y ansible2

# install haproxy only if you plan to run load balancer on bastion(A dedicated load balancer is recommended)
sudo wget https://raw.githubusercontent.com/praveensiddu/aws/main/bastion/install_haproxy.sh -O install_haproxy.sh
bash install_haproxy.sh

echo "set -o vi" >> ~/.bashrc
sudo bash -c 'echo set -o vi >> ~root/.bashrc'

mkdir ~/keys
