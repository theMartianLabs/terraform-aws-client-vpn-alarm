variable "region" {
  type    = string
  default = "us-east-1"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "client_vpn_server_id" {
  type        = string
  description = "Client VPN endpoint ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list()
  description = "Subent IDs"
}

variable "client_vpn_endpoint_id" {
  type        = string
  description = "Client VPN endpoint ID"
}

variable "tags" {
  type = map(any)
  default = {
    "Env"   = "Prod"
    "Owner" = "Greatzlab.com"
  }
  description = "Resource tags"
}
