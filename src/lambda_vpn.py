import os
import time
import json
import boto3

print('Begin execution')

def lambda_handler(event, context):
    ssm = boto3.client('ssm')
    InstanceID = os.environ["client_vpn_InstanceIds"]

    response = ssm.send_command(
        InstanceIds=[InstanceID],
        DocumentName="AWS-RunShellScript",
        Parameters={'commands': ['bash /Scripts/clientScript.sh']}
    )
    print('End execution')