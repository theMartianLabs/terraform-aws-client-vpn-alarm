output cloudwatch_alarm_arn {
  value = aws_cloudwatch_metric_alarm.cloudwatch_alarm_client_vpn_clrExpiry.arn
}

output "sns_topic" {
  value = aws_sns_topic.sns_monitoring_topic.arn
}

output "sns_topic_subscription" {
  value = aws_sns_topic_subscription.sns_target.arn
}

output "lambda" {
  value = aws_lambda_function.client_vpn_lambda.arn
}

output "alarm_security_group" {
  value = aws_security_group.client_vpn_lambda_sg.id
}