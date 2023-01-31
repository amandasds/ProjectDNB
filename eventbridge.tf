resource "aws_cloudwatch_event_rule" "lambda_eventbridge_rule" {
  name = "detect-security-group-changes"
  description = "A CloudWatch Event Rule that detects changes to security groups and publishes change events to an SNS topic for notification."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "AuthorizeSecurityGroupIngress",
      "AuthorizeSecurityGroupEgress",
      "RevokeSecurityGroupIngress",
      "RevokeSecurityGroupEgress",
      "ModifySecurityGroupRules",
      "CreateSecurityGroup",
      "DeleteSecurityGroup"
    ]
  }
}
PATTERN

}
resource "aws_cloudwatch_event_target" "eventbridge_lambda_target" {
  arn = aws_lambda_function.terraform_lambda_func.arn
  rule = aws_cloudwatch_event_rule.lambda_eventbridge_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.lambda_eventbridge_rule.arn
}



