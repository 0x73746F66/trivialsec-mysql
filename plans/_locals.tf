locals {
    aws_default_region      = "ap-southeast-2"
    aws_master_account_id   = 984310022655
    linode_default_region   = "ap-southeast"
    linode_default_image    = "linode/alpine3.14"
    linode_default_type     = "g6-nanode-1"
    # linode_default_type     = "g6-standard-1"
    hosted_zone             = "Z04169281YCJD2GS4F5ER"
    allowed_ip_addresses    = "172.105.188.231" # space delimited
    mysql_replica_hostname  = "prd-rr.trivialsec.com"
    mysql_main_hostname     = "prd-main.trivialsec.com"
    mysql_database          = "trivialsec"
}
