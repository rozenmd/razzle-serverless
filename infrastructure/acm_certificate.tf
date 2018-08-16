
variable "san_domains" {
  default = [
    "www.recordmyweight.com"
  ]
}

data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = "${var.san_domains}"
  provider = "aws.east"
}

resource "aws_route53_record" "cert" {
  count   = "${length(var.san_domains) + 1}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
    provider = "aws.east"
    certificate_arn = "${aws_acm_certificate.cert.arn}"
    validation_record_fqdns = ["${aws_route53_record.cert.*.fqdn}" ]
}
