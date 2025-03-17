resource "aws_route53_record" "eks_ingress" {
  depends_on = [ kubectl_manifest.prometheus_ingress ]
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "prometheus.${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.lb.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "eks_grafana" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "grafana.${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.lb.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

data "aws_lb" "lb" {
  depends_on = [ null_resource.wait_for_alb ]
  name = "${var.environment}-alb"  
}
data "aws_route53_zone" "zone" {
  name = "devops4solutions.com"  # Replace with your domain
}
