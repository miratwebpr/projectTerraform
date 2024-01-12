resource "aws_route53_zone" "main" {
  name = "salokhiddin.link"   # Replace it with your domain name
}

resource "aws_route53_record" "writer" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "writer"
  type    = "CNAME"
  ttl     = 90
  records = [aws_lb.projectLB.dns_name]  
}
resource "aws_route53_record" "reader1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "reader1"
  type    = "CNAME"
  ttl     = 90
  records = [aws_lb.projectLB.dns_name]  
}
resource "aws_route53_record" "reader2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "reader2"
  type    = "CNAME"
  ttl     = 90
  records = [aws_lb.projectLB.dns_name]  
}
resource "aws_route53_record" "wordpress" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "wordpress"
  type    = "CNAME"
  ttl     = 90
  records = [aws_lb.projectLB.dns_name]
}