import boto3
region = 'us-east-1'
instances = ['i-12345cb6de4f78g9h', 'i-08ce9b2d7eccf6d26']

ec2 = boto3.resource('ec2')

instances = ec2.instances.filter(
    Filters = [{'Name'   : 'instance-state-name',
                'Values' : ['running']}])

iids = [i.id for i in instances]

ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=iids)
    print('stopped your instances: ' + str(iids))
