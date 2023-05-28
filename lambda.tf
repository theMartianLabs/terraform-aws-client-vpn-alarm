
resource "aws_cloudwatch_log_group" "client_vpn_lambda_logs" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 3
}

resource "aws_iam_role" "client_vpn_lambda_iam" {
  name  = local.lambda_role_name

  assume_role_policy = file("${path.module}/policies/lambda_trust_policy.json")
}

resource "aws_iam_policy" "client_vpn_lambda_policy" {
  name  = local.lambda_iam_policy_name

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

