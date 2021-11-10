resource "random_string" "mysql_replica_password" {
    length  = 32
    special = false
}
resource "random_string" "linode_replica_password" {
    length  = 32
    special = true
}
resource "linode_instance" "mysql_replica" {
  label             = local.mysql_hostname
  group             = "SaaS"
  tags              = ["SaaS"]
  region            = local.linode_default_region
  type              = local.linode_default_type
  image             = local.linode_default_image
  authorized_keys   = length(var.public_key) == 0 ? [] : [
    var.public_key
  ]
  authorized_users  = [
    var.allowed_linode_username
  ]
  root_pass         = random_string.linode_replica_password.result
  stackscript_id    = linode_stackscript.mysql_replica.id
  stackscript_data  = {
    "FQDN"                  = local.mysql_hostname
    "MYSQL_DATABASE"        = local.mysql_database
    "MYSQL_ROOT_PASSWORD"   = random_string.mysql_replica_password.result
    "MYSQL_PORT"            = 3306
    "AWS_REGION"            = local.aws_default_region
    "AWS_ACCESS_KEY_ID"     = var.aws_access_key_id
    "AWS_SECRET_ACCESS_KEY" = var.aws_secret_access_key
  }
  alerts {
      cpu            = 90
      io             = 10000
      network_in     = 10
      network_out    = 10
      transfer_quota = 80
  }
}
