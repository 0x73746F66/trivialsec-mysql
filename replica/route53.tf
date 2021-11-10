resource "aws_route53_record" "replica_a" {
    zone_id = local.route53_hosted_zone
    name    = local.mysql_hostname
    type    = "A"
    ttl     = 300
    records = linode_instance.mysql_replica.ipv4
}
resource "aws_route53_record" "replica_aaaa" {
    zone_id = local.route53_hosted_zone
    name    = local.mysql_hostname
    type    = "AAAA"
    ttl     = 300
    records = [
        element(split("/", linode_instance.mysql_replica.ipv6), 0)
    ]
}
