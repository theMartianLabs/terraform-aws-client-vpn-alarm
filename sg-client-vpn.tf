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