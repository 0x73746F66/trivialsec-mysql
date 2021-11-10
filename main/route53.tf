resource "aws_route53_record" "main_a" {
    zone_id = local.route53_hosted_zone
    name    = local.mysql_hostname
    type    = "A"
    ttl     = 300
    records = linode_instance.mysql_main.ipv4
}
resource "aws_route53_record" "main_aaaa" {
    zone_id = local.route53_hosted_zone
    name    = local.mysql_hostname
    type    = "AAAA"
    ttl     = 300
    records = [
        element(split("/", linode_instance.mysql_main.ipv6), 0)
    ]
}
