data "aws_route53_zone" "main" {
  name = "mironthis.link" # Replace it with your dns name
}

resource "aws_route53_record" "writer" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "writer"
  type    = "A"

  alias {
    name                   = aws_lb.projectLB.dns_name
    zone_id                = aws_lb.projectLB.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "reader1" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "reader1"
  type    = "A"

  alias {
    name                   = aws_lb.projectLB.dns_name
    zone_id                = aws_lb.projectLB.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "reader2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "reader2"
  type    = "A"

  alias {
    name                   = aws_lb.projectLB.dns_name
    zone_id                = aws_lb.projectLB.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "wordpress"
  type    = "A"

  alias {
    name                   = aws_lb.projectLB.dns_name
    zone_id                = aws_lb.projectLB.zone_id
    evaluate_target_health = true
  }
}
