resource "aws_route53_record" "node1Arecord" {
  allow_overwrite = true
  zone_id = var.route53zoneid
  name    = "rsnode1.${var.dns_zone_dns_name}"
  type    = "A"
  ttl     = "60"

  records = [ "${google_compute_instance.node1.network_interface.0.access_config.0.nat_ip}" ]
}

resource "aws_route53_record" "nodeXArecord" {
  count = var.clustersize - 1
  
  allow_overwrite = true
  zone_id = var.route53zoneid
  name    = "rsnode${count.index + 1 + 1}.${var.dns_zone_dns_name}"
  type    = "A"
  ttl     = "60"

  records = [ google_compute_instance.nodeX[count.index].network_interface.0.access_config.0.nat_ip ]
}


resource "aws_route53_record" "memtierArecord" {
  allow_overwrite = true
  zone_id = var.route53zoneid
  name    = "memtier.${var.dns_zone_dns_name}"
  type    = "A"
  ttl     = "60"

  records = [ "${google_compute_instance.memtier_instance.network_interface.0.access_config.0.nat_ip}" ]
}

resource "aws_route53_record" "clusterNSrecord" {
  allow_overwrite = true
  name            = "rscluster.${var.dns_zone_dns_name}"
  ttl             = 60
  type            = "NS"
  zone_id         = var.route53zoneid

  records = flatten([local.n1, flatten(local.nX)])
}

locals {
  n1 = aws_route53_record.node1Arecord.name
  nX = [for xx in aws_route53_record.nodeXArecord : xx.name]
} 