###########
# SNS Topic
###########
resource "aws_sns_topic" "sns_monitoring_topic" {
  name = local.sns_topic_name
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

###########
# SNS Lambda Resources
###########
resource "aws_cloudwatch_log_group" "client_vpn_lambda_logs" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 3
}

resource "aws_iam_role" "client_vpn_lambda_iam" {
  name = local.lambda_role_name

  assume_role_policy = file("${path.module}/policies/lambda_trust_policy.json")
}

resource "aws_iam_policy" "client_vpn_lambda_policy" {
  name = local.lambda_iam_policy_name

  policy = data.template_file.client_vpn_lambda_template.rendered
}

resource "aws_iam_role_policy_attachment" "client_vpn_lambda_policy_attach" {
  role       = aws_iam_role.client_vpn_lambda_iam.name
  policy_arn = aws_iam_policy.client_vpn_lambda_policy.arn
}

resource "aws_lambda_function" "client_vpn_lambda" {
  function_name    = local.function_name
  role             = aws_iam_role.client_vpn_lambda_iam.arn
  handler          = local.lambda_handler
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = data.archive_file.client_vpn_file.output_path
  source_code_hash = data.archive_file.client_vpn_file.output_base64sha256

  vpc_config {
    subnet_ids         = flatten(var.subnet_ids)
    security_group_ids = [aws_security_group.client_vpn_lambda_sg.id]
  }
  environment {
    variables = {
      client_vpn_InstanceIds = var.client_vpn_instance_id
    }
  }
}

resource "aws_lambda_permission" "client_vpn_lambda" {
  statement_id  = local.statement_id
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.client_vpn_lambda.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.sns_monitoring_topic.arn
}

resource "aws_iam_role_policy_attachment" "aws_lambda_execute_policy_attach" {
  role       = aws_iam_role.client_vpn_lambda_iam.name
  policy_arn = data.aws_iam_policy.aws_lambda_execute_policy.arn
}

resource "aws_iam_role_policy_attachment" "aws_ssm_policy_attach" {
  role       = aws_iam_role.client_vpn_lambda_iam.name
  policy_arn = data.aws_iam_policy.aws_ssm_policy.arn
}

###########
# Security Group
###########
resource "aws_security_group" "client_vpn_lambda_sg" {
  name        = "client_vpn_lambda_sg"
  description = "Security Group for the lambda"
  vpc_id      = var.vpc_id

  tags = merge({
    Name = "client_vpn_lambda_sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "client_vpn_lambda_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.client_vpn_lambda_sg.id
}

resource "aws_security_group_rule" "client_vpn_lambda_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.client_vpn_lambda_sg.id
}
