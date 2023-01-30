resource "aws_cloudwatch_event_rule" "lambda_eventbridge_rule" {
  name = "lambda_eventbridge_rule"
  description = "retry scheduled every 2 min"
  schedule_expression = "rate(2 minutes)"
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