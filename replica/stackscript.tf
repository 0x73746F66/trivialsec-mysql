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
