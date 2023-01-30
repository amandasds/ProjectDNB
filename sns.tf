resource "aws_sns_topic" "reportsg" {
  name = "reportsg"
}

locals {
  emails = ["amandass@id.uff.br"]
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(local.emails)
  topic_arn = aws_sns_topic.reportsg.arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}