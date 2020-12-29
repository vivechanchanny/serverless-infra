# Create Bastion instance
## Create AWS Linux2 Instance using this as cloud init
- https://raw.githubusercontent.com/vivechanchanny/aws-archery/main/bastion/cloud-init.sh
> If you forgot to create the instance with user-data you can wget this file and execute it
## Configure Bastion
### Configure programatic access
We would be launching insstances using this bastion host. So enable programatic access from Bastion host and remove it when you are done.
- Create a non root user in IAM( since root account must not be used for programatic access). Assign AdministratorAccess privilege to the user( Ideally only limited privilege must be given)
- Login as that IAM user. "Create access key" and download from here https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials
- Run "aws configure" on bastion host.
  - AWS Access Key ID [None]: 
  - AWS Secret Access Key [None]: 
  - Default region name [None]: us-east-1
