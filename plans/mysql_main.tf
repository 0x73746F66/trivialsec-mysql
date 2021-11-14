resource "random_string" "mysql_main_password" {
    length  = 32
    special = false
}
resource "random_string" "linode_main_password" {
    length  = 32
    special = true
}
resource "linode_instance" "mysql_main" {
  label             = local.main_hostname
  group             = "SaaS"
  tags              = ["Database", "Shared"]
  region            = local.linode_default_region
  type              = local.linode_default_type
  image             = local.linode_default_image
  authorized_keys   = length(var.public_key) == 0 ? [] : [
    var.public_key
  ]
  authorized_users  = length(var.allowed_linode_username) == 0 ? [] : [
    var.allowed_linode_username
  ]
  root_pass         = random_string.linode_main_password.result
  stackscript_id    = linode_stackscript.mysql_main.id
  stackscript_data  = {
    "FQDN"                  = local.main_hostname
    "MYSQL_DATABASE"        = local.mysql_database
    "MYSQL_PORT"            = 3306
    "AWS_REGION"            = local.aws_default_region
    "MYSQL_ROOT_PASSWORD"   = random_string.mysql_main_password.result
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
output "mysql_main_id" {
  value = linode_instance.mysql_main.id
}
output "mysql_main_ipv4" {
  value = [for ip in linode_instance.mysql_main.ipv4 : join("/", [ip, "32"])]
}
output "mysql_main_ipv6" {
  value = linode_instance.mysql_main.ipv6
}
output "mysql_main_password" {
  sensitive = true
  value = random_string.mysql_main_password.result
}
output "mysql_main_linode_password" {
  sensitive = true
  value = random_string.linode_main_password.result
}
