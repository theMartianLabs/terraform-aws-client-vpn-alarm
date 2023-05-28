module aws_client_vpn_alarm { 
    source                       = "./"
    audit_account_id             =  var.account_id #In the event your logs are kept in another account
    account_id                   =  var.account_id
    client_vpn_instance_id       =  var.client_vpn_server_id
    vpc_id                       =  var.vpc_id
    subnet_ids                   =  var.subnet_ids
    crl_alarm_threshold          =  15
    client_vpn_endpoint_id       =  var.client_vpn_endpoint_id
    tags                         =  var.tags
}


