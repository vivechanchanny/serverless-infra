# Welcome to Tomcat on K3s in AWS
This page contains instructions to run a tomcat container on K3s in AWS.

## Create Ubuntu instance usng this as cloud init
Either create using CLI or manually on the UI.
- Make sure bastion host is configured for programmatic access https://github.com/vivechanchanny/wordpress-serverlesss/tree/main/bastion#configure-programatic-access
- Find your keypair name that you use to SSH from bastion here https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:
### Using CLI
- Set environment varaible to the SSH key name used to SSH from bastion
export MYSSHKEYNAME=aws-swift-bastion-praveen
- rm -f create-instance.sh && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/tomcat-on-k3s/create-instance.sh
- bash create-instance.sh
### Using GUI
- Create Ubuntu instance with 
  - SSH key name used to SSH from bastion
  - https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/tomcat-on-k3s/cloud-init.sh
> If you forgot to create the instance with user-data you can wget this file and execute it
- if you are routing all traffic through a proxy(Bastion or load balancer) then you need only ssh from bastion in security group. Else open both http and https in security group.

## Install K3S
- curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
## Build HelloWorld python container image
- rm -f app.py && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/tomcat-on-k3s/helloworld-python/sourcecode/app.py
- rm -f Dockerfile && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/tomcat-on-k3s/helloworld-python/sourcecode/Dockerfile
- sudo docker build . -t helloworld
- sudo docker save helloworld > helloworld.tar
- tar tvf helloworld.tar
- Copy the helloworld.tar to K3s host
  - scp ./helloworld.tar ubuntu@172.31.18.237:.



On K3S host
Run the following command to find the current count of images
sudo k3s ctr images list -q
sudo ls -l /var/lib/rancher/k3s/agent/containerd/io.containerd.content.v1.content/blobs/sha256 |wc -l
kubectl get pods | grep helloworld | cut -d ' ' -f 1
kubectl apply -f https://raw.githubusercontent.com/myannou/k3d-demo/master/nginx.yaml
kubectl get pods
sudo crictl image list
curl http://localhost:8081
kubectl get pods
curl http://localhost:8082
curl http://localhost:8099
netstat -an |grep 8081
curl http://localhost:8081
curl http://localhost:80
kubectl port-forward $(kubectl get pods | grep nginx | cut -d ' ' -f 1) 80 > log 2>&1 &
 kubectl get pods
 netstat -an |grep 80
kubectl get pods
kubectl exec
kubectl exec --help
kubectl get pods
kubectl exec nginx-7848d4b86f-w46ng -- /bin/bash
kubectl exec nginx-7848d4b86f-w46ng -- date
 kubectl exec nginx-7848d4b86f-w46ng -- /bin/bash -il
kubectl exec nginx-7848d4b86f-w46ng -i -t -- /bin/bash -il

The examples in this folder contains instructions to quickly Install K3s and configure TLS.

## Steps

## Deploy tomcat container on K3s
https://stackoverflow.com/questions/54341432/deploy-war-in-tomcat-on-kubernetes

> Note of thanks. This README.md was edited using https://stackedit.io/app#.
