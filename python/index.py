import boto3
import json
import os

snsTargetArn = os.environ['SNS_TARGET_ARN']
sns = boto3.client('sns')
ec2 = boto3.client("ec2")
describe_instances_response = ec2.describe_instances()
securityGroups = ec2.describe_security_groups(
    Filters=[
        {
        "Name": "ip-permission.cidr",
        "Values": ["0.0.0.0/0"]   
        }
    ]
)

def find_sg_vul():
    for sg in securityGroups['SecurityGroups']:
        for instances in describe_instances_response["Reservations"]:
            if 'PublicIpAddress' in instances["Instances"][0]:
                security_groups = instances["Instances"][0]["SecurityGroups"]
                for sg in security_groups:
                    securityGroupsRules = ec2.describe_security_group_rules(
                    Filters=[
                        {
                            'Name': 'group-id',
                            'Values': [sg['GroupId']]
                        },
                    ])
                    for rule in securityGroupsRules['SecurityGroupRules'] :
                        if rule['IsEgress'] == False and 'CidrIpv4' in rule and rule['CidrIpv4'] == '0.0.0.0/0':
                            delete_sg_rule(sg['GroupId'], rule['SecurityGroupRuleId'])
                            send_sns_message(sg['GroupId'], rule['SecurityGroupRuleId'], rule['CidrIpv4'], rule['IpProtocol'], rule['FromPort'], rule['ToPort'])
                        else:
                            print("SG " + sg['GroupId'], "Rule ok: " + rule['SecurityGroupRuleId'])
                        if rule['IsEgress'] == False and 'CidrIpv6' in rule and rule['CidrIpv6'] == '::/0':
                            delete_sg_rule(sg['GroupId'], rule['SecurityGroupRuleId'])
                            send_sns_message(sg['GroupId'], rule['SecurityGroupRuleId'], rule['CidrIpv6'], rule['IpProtocol'], rule['FromPort'], rule['ToPort'])    
                        else:
                            print("SG " + sg['GroupId'], "Rule ok: " + rule['SecurityGroupRuleId']) 
            else:
                print("Instance without public access: " + instances["Instances"][0]["InstanceId"]) 
    return 0         
            
def delete_sg_rule(sg_id, sgr_id):    
    ec2.revoke_security_group_ingress(
        GroupId=sg_id,
        SecurityGroupRuleIds=[sgr_id]
    )
    print("sg rule", sgr_id, "deleted")
    
def send_sns_message(sg_id, sgr_id, sgr_cidr, sgr_prot, sgr_fport, sgr_tport):
    message={
        'Title': ' This security_group is vulnerable: ' + sg_id, 
        'RuleID': sgr_id,
        'Cidr': sgr_cidr,
        'protocol': sgr_prot,
        'FromPort': str(sgr_fport) + ' ToPort: ' + str(sgr_tport),
        'Status':'Deleted'
    }
    sns.publish(
    TargetArn=snsTargetArn,
    Message=json.dumps({'default': json.dumps(message)}),
    MessageStructure='json'
)
    
def lambda_handler(event, context):
    return find_sg_vul()