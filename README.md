# AWS Client VPN CRL CloudWatch Alarm

This module creates a CloudWatch Alarm to monitor the Certificate Revocation List (CRL) of the Client VPN Service.

The AWS Client VPN CRL CloudWatch Alarm automates the process of resolving VPN connectivity failures caused by an expired CRL. This alarm utilizes an existing CloudWatch metric (CrlDaysToExpiry) to monitor the remaining days until CRL expiration.

## Example Implementation
```
module aws_client_vpn_alarm { 
    source                       = "./"
    audit_account_id             =  var.account_id #In the event your logs are kept in another account
    account_id                   =  var.account_id
    client_vpn_instance_id       =  aws_instance.client_vpn_server.id
    vpc_id                       =  aws_vpc.my_vpc.id
    subnet_ids                   =  data.aws_subnets.subnet_ids.ids
    crl_alarm_threshold          =  15
    client_vpn_endpoint_id       =  aws_ec2_client_vpn_endpoint.client_vpn.id
    tags                         =  var.tags
}

```