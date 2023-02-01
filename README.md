# ProjectDNB

### The Problem:
Security Groups are created and attached to EC2 instances. And these Security Groups may include ingress that could be considered insecure. An existing or launched instance should not be allowed to have ingress with 0.0.0.0/0 and port any nor any other specific port.

### The Requirements:
#### In terraform:
- Create event handlers for the events
- Create the lambda deployment
- Add logging in cloudwatch
#### In Python:
- Write the Lambda event handler which is responding to the events
- Check if the CIDR is 0.0.0.0/0
- Remove the rule if it is added
- Write to a predefined SNS Topic for reporting

### The Solution:
In order to handle this situation, there was created an automation using terraform IaC and python code.
It will use Amazon EventBridge rules to react to API calls made by AWS EC2 that are recorded by Amazon CloudTrail. A AWS Lambda will be invoked to check the ingress rules of the Security Group and modify the Security group if necessary. The same AWS Lambda remediates on security group being attached to an EC2 instance in a public subnet / with public ip, removing this ingress rule. Once the remediation was necessary, it will call SNS topic to send an notification through email. The python code used for the lambda function is in a random S3 bucket and all the logs is saved in AWS Cloudwatch Logs.

#### Architecture:
![Image](https://github.com/amandasds/ProjectDNB/blob/main/architecture.png)

#### Terraform graph: ![Image](https://user-images.githubusercontent.com/75995105/215519082-a26669b8-c4ce-4eb9-8d52-1fcdbbc06859.png)

