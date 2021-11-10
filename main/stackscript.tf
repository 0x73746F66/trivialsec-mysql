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
