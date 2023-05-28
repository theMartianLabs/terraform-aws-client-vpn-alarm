locals {
  cloudwatch_log_group_name = "/aws/lambda/${local.function_name}"
  lambda_iam_policy_name    = "ClientVPNLambdaRolePolicy"
  function_name             = "client_vpn_lambda"
  lambda_role_name          = "ClientVPNLambdaRole"
  lambda_handler            = "lambda_vpn.lambda_handler"
  statement_id              = "AllowExecutionFromSNS"
  alarm_topic               = length(var.sns_topic_arn) == 0 ? aws_sns_topic.sns_monitoring_topic.arn : var.sns_topic_arn
  sns_topic_name            = "client-vpn-sns"
}