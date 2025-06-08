import boto3
import os

client = boto3.client('ec2')
instance_id = os.environ['INSTANCE_ID']

def lambda_handler(event, context):
    response = client.start_instances(InstanceIds=[instance_id])
    print(response)
