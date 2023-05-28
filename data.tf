data "aws_iam_policy" "aws_lambda_execute_policy" {
  name  = "AWSLambdaExecute"
}

data "aws_iam_policy" "aws_ssm_policy" {
  name  = "AmazonSSMFullAccess"
}

data "archive_file" "client_vpn_file" {
  type             = "zip"
  source_file      = "${path.module}/src/lambda_vpn.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/src/lambda_vpn.py.zip"
}

data "template_file" "client_vpn_lambda_template" {
  template = file("${path.module}/policies/client_vpn_lambda_iam_policy.json")

  vars = {
    account              = var.account_id
    region               = var.region
    lambda_function_name = local.cloudwatch_log_group_name
  }
}

data "template_file" "sns_policy" {
  template = file("${path.module}/policies/sns-policy.json")

  vars = {
    region            = var.region
    audit_account_id  = var.audit_account_id
    sns_name          = local.sns_topic_name
    source_account_id = var.account_id
  }
}

