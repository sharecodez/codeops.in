resource "aws_route53_record" "Jitsi" {
  zone_id = data.aws_route53_zone.parent_subdomain.zone_id
  name    = "${local.subdomain}.${var.parent_subdomain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.Jitsi.public_ip]
}

