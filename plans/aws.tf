resource "aws_ssm_parameter" "ssm_linode_main_password" {
  name        = "/linode/${linode_instance.mysql_main.id}/linode_main_password"
  description = join(", ", linode_instance.mysql_main.ipv4)
  type        = "SecureString"
  value       = random_string.linode_main_password.result
  tags = {
    cost-center = "saas"
  }
}
resource "aws_ssm_parameter" "ssm_linode_replica_password" {
  name        = "/linode/${linode_instance.mysql_replica.id}/linode_replica_password"
  description = join(", ", linode_instance.mysql_replica.ipv4)
  type        = "SecureString"
  value       = random_string.linode_replica_password.result
  tags = {
    cost-center = "saas"
  }
}
resource "aws_ssm_parameter" "ssm_mysql_main_password" {
  name        = "/Prod/Deploy/trivialsec/mysql_main_password"
  description = join(", ", linode_instance.mysql_main.ipv4)
  type        = "SecureString"
  value       = random_string.mysql_main_password.result
  tags = {
    cost-center = "saas"
  }
}
resource "aws_ssm_parameter" "ssm_mysql_replica_password" {
  name        = "/Prod/Deploy/trivialsec/mysql_replica_password"
  description = join(", ", linode_instance.mysql_replica.ipv4)
  type        = "SecureString"
  value       = random_string.mysql_replica_password.result
  tags = {
    cost-center = "saas"
  }
}
