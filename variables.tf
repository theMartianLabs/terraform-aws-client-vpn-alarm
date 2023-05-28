variable "region" {
  description = "The AWS region to provision the resources"
  type        = string
  default     = "eu-west-1"
}

variable "tags" {
  default = {}
  type    = map(any)
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs for the Lambda"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "Account ID"
}

variable "audit_account_id" {
  type        = string
  default     = ""
  description = "Audit account ID"
}

variable "organisation_id" {
  type        = string
  default     = ""
  description = "Organisation ID"
}

variable "client_vpn_instance_id" {
  type        = string
  default     = "i-XXXXXXXXXXXXXXX"
  description = "ID for Client VPN server instance"
}

variable "client_vpn_endpoint_id" {
  type        = string
  default     = "i-XXXXXXXXXXXXXXX"
  description = "ID for Client VPN endpoint, to be supplied when the option to create endpoint is false"
}

variable "crl_alarm_threshold" {
  description = "This is the number of days left until CRL expires. Used to trigger the alarm"
  type        = number
  default     = 15
}

variable "sns_topic_arn" {
  type        = string
  description = "This is the arn for a SNS topic if you wish to aggregate the messages in a single topic"
  default     = ""
}

variable "timeout" {
  type    = number
  default = 180
}

variable "runtime" {
  type        = string
  default     = "python3.9"
  description = "Runtime for lambda"
}

