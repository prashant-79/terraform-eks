# testing to use the external ALB instead of the one which kubernetes created
/*resource "kubectl_manifest" "prometheus_ingress_1" {
  depends_on = [ helm_release.prometheus]
  yaml_body = jsonencode({
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "prometheus-ingress1"
      namespace = "monitoring"
      annotations = {
        "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"      = "ip"
        "alb.ingress.kubernetes.io/healthcheck-path" = "/-/ready"
        "alb.ingress.kubernetes.io/load-balancer-name" = "${var.environment}-alb"
        "alb.ingress.kubernetes.io/group.name": "myapp"
      "alb.ingress.kubernetes.io/security-groups": "sg-067327d5ae993e1e8, sg-08a4bded7d44efc36"

      }
    }
    spec = {
      ingressClassName = "alb"
      rules = [{
        host = "prometheus.${var.environment}.devops4solutions.com"
        http = {
          paths = [{
            path     = "/"
            pathType = "Prefix"
            backend = {
              service = {
                name = "prometheus-server"
                port = {
                  number = 80
                }
              }
            }
          }]
        }
      }]
    }
  })
}

/*
resource "kubectl_manifest" "grafana_ingress" {
        depends_on = [ kubectl_manifest.prometheus_ingress]

  yaml_body = jsonencode({
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "grafana-ingress"
      namespace = "monitoring"
      annotations = {
        "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"      = "ip"
        "alb.ingress.kubernetes.io/healthcheck-path" = "/api/health"
        "alb.ingress.kubernetes.io/group.name": "myapp"
        "alb.ingress.kubernetes.io/load-balancer-name" = "${var.environment}-alb"
        "alb.ingress.kubernetes.io/security-groups": "${aws_security_group.alb.id},${aws_security_group.alb-internal.id}"

      }
    }
    spec = {
      ingressClassName = "alb"
      rules = [{
        host = "grafana.${var.environment}.devops4solutions.com"
        http = {
          paths = [{
            path     = "/"
            pathType = "Prefix"
            backend = {
              service = {
                name = "grafana"
                port = {
                  number = 80
                }
              }
            }
          }]
        }
      }]
    }
  })
}*/
