data "aws_route53_zone" "site_zone" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "cf_alias_A" {
  zone_id = "${data.aws_route53_zone.site_zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.site.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.site.hosted_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cf_alias_AAAA" {
  zone_id = "${data.aws_route53_zone.site_zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = "${aws_cloudfront_distribution.site.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.site.hosted_zone_id}"
    evaluate_target_health = true
  }
}
