if [[ $MYSSHKEYNAME == "" ]]
then
        echo "Set env MYSSHKEYNAME to the name of ssh key on bastion host used to access this instance. You can find your key name here"
        echo "https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:"
        exit 1
fi
export UBUNTU_AMI=$(aws ec2 describe-images  --owners 099720109477  --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*  --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text)
rm -f cloud-init.sh && wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/tomcat-on-k3s/cloud-init.sh

aws ec2 run-instances --image-id $UBUNTU_AMI --count 1 --instance-type t2.micro --key-name  $MYSSHKEYNAME 
