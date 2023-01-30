# ProjectDNB

The Problem:
Security Groups are created and attached to EC2 instances. And these Security Groups may include ingress that could be considered insecure. Create a Lambda that is deployed with Terraform and executed on Security Group change or attachment and remediate the issue.
Please write a terraform module that includes Lambda(s) for handling this scenario.
An existing or launched instance should not be allowed to have ingress with 0.0.0.0/0 and port any nor any other specific port.
Any time the security group is modified the Lambda should be called to check the ingress rules of the Security Group and modify the Security group if necessary.

The Requirements:
In terraform do the following the following:
• Create event handlers for the events
• Create the lambda deployment
• Add logging in cloudwatch
In Python:
• Write the Lambda event handler which is responding to the events
• Check if the CIDR is 0.0.0.0/0
• Remove the rule if it is added
• Write to a predefined SNS Topic for reporting
If possible have the lambda remediate on security group being attached to an EC2 instance
in a public subnet / with public ip.

The Solution:
