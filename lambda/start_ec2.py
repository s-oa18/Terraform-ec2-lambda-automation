import json
import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = os.environ['INSTANCE_ID']
    response = ec2.start_instances(InstanceIds=[instance_id])
    print("Start response:", response)
