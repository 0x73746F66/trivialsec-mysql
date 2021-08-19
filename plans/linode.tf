data "linode_profile" "me" {}
data "local_file" "alpine_mysql_main" {
    filename = "${path.root}/../bin/alpine-main"
}
data "local_file" "alpine_mysql_replica" {
    filename = "${path.root}/../bin/alpine-replica"
}
resource "random_string" "mysql_main_password" {
    length  = 32
    special = true
}
resource "random_string" "mysql_replica_password" {
    length  = 32
    special = true
}
resource "random_string" "linode_main_password" {
    length  = 32
    special = true
}
resource "random_string" "linode_replica_password" {
    length  = 32
    special = true
}
resource "linode_stackscript" "mysql_main" {
  label = "mysql-main"
  description = "Installs mysql main"
  script = data.local_file.alpine_mysql_main.content
  images = [local.linode_default_image]
}
resource "linode_stackscript" "mysql_replica" {
  label = "mysql-replica"
  description = "Installs mysql replica"
  script = data.local_file.alpine_mysql_replica.content
  images = [local.linode_default_image]
}
resource "linode_instance" "mysql_main" {
  label             = "mysql-main"
  group             = "SaaS"
  tags              = ["SaaS"]
  region            = local.linode_default_region
  type              = local.linode_default_type
  image             = local.linode_default_image
  authorized_keys   = length(var.public_key) == 0 ? [] : [
    var.public_key
  ]
  authorized_users  = [
    data.linode_profile.me.username,
    "chrislangton"
  ]
  root_pass         = random_string.linode_main_password.result
  stackscript_id    = linode_stackscript.mysql_main.id
  stackscript_data  = {
    "MYSQL_ROOT_PASSWORD" = random_string.mysql_main_password.result
    "AWS_ACCESS_KEY_ID" = var.aws_access_key_id
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
resource "linode_stackscript" "mysql_replica" {
  label = "mysql-replica"
  description = "Installs mysql replica"
  script = data.local_file.alpine_mysql_replica.content
  images = [local.linode_default_image]
}
resource "linode_instance" "mysql_replica" {
  label             = "mysql-replica"
  group             = "SaaS"
  tags              = ["SaaS"]
  region            = local.linode_default_region
  type              = local.linode_default_type
  image             = local.linode_default_image
  authorized_keys   = length(var.public_key) == 0 ? [] : [
    var.public_key
  ]
  authorized_users  = [
    data.linode_profile.me.username,
    "chrislangton"
  ]
  root_pass         = random_string.linode_replica_password.result
  stackscript_id    = linode_stackscript.mysql_replica.id
  stackscript_data  = {
    "MYSQL_ROOT_PASSWORD" = random_string.mysql_replica_password.result
    "AWS_ACCESS_KEY_ID" = var.aws_access_key_id
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