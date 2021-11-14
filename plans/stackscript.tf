data "local_file" "alpine_mysql_main" {
    filename = "${path.root}/../bin/alpine-main"
}
resource "linode_stackscript" "mysql_main" {
  label = "mysql-main"
  description = "Installs mysql"
  script = data.local_file.alpine_mysql_main.content
  images = [local.linode_default_image]
  rev_note = "initial version"
}
data "local_file" "alpine_mysql_replica" {
    filename = "${path.root}/../bin/alpine-replica"
}
resource "linode_stackscript" "mysql_replica" {
  label = "mysql-replica"
  description = "Installs mysql read replica"
  script = data.local_file.alpine_mysql_replica.content
  images = [local.linode_default_image]
  rev_note = "initial version"
}
output "mysql_main_stackscript_id" {
  value = linode_stackscript.mysql_main.id
}
output "mysql_replica_stackscript_id" {
  value = linode_stackscript.mysql_replica.id
}
