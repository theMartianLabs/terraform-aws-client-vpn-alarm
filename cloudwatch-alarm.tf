resource "aws_sns_topic" "sns_monitoring_topic" {
  name  = local.sns_topic_name
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn    = aws_sns_topic.sns_monitoring_topic.arn
  policy = data.template_file.sns_policy.rendered
}

resource "aws_sns_topic_subscription" "sns_target" {
  topic_arn = local.alarm_topic
  protocol  = "lambda"
  endpoint  = aws_lambda_function.client_vpn_lambda.arn
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm_client_vpn_clrExpiry" {
  alarm_name          = "client-vpn-Crl-expiry"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CrlDaysToExpiry"
  namespace           = "AWS/ClientVPN"
  period              = "300"
  statistic           = "Minimum"
  threshold           = var.crl_alarm_threshold 
  alarm_description   = "Monitors number of days from clr expiry"
  alarm_actions       = ["${local.alarm_topic}"]

  dimensions = {
    Endpoint = var.client_vpn_endpoint_id
  }
  treat_missing_data = "notBreaching"
}



