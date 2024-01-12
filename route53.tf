resource "aws_route53_zone" "myZone" {
  name = "example.com"
}

resource "aws_route53_record" "myRecord" {
  zone_id = aws_route53_zone.myZone.zone_id
  name    = "example.com" # OR "www.example.com"
  type    = "A" # OR "AAAA"

  alias {
      name                   = aws_lb.MYALB.dns_name
      zone_id                = aws_lb.MYALB.zone_id
      evaluate_target_health = true
  }
}