resource "kubectl_manifest" "prometheus_ingress" {
  depends_on = [ helm_release.prometheus]
  yaml_body = jsonencode({
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "prometheus-ingress"
      namespace = "monitoring"
      annotations = {
        "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"      = "ip"
        "alb.ingress.kubernetes.io/healthcheck-path" = "/-/ready"
        "alb.ingress.kubernetes.io/load-balancer-name" = "${var.environment}-alb"
        "alb.ingress.kubernetes.io/certificate-arn" = "${data.aws_acm_certificate.acm.arn}"
        "alb.ingress.kubernetes.io/group.name": "myapp"
        "alb.ingress.kubernetes.io/ssl-redirect"       = "443"
       "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"
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
        "alb.ingress.kubernetes.io/ssl-redirect" = "443"
        "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/load-balancer-name" = "${var.environment}-alb"

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
}

# Wait until the ALB is fully active
resource "null_resource" "wait_for_alb" {
  depends_on = [kubectl_manifest.prometheus_ingress]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for ALB to become active..."
      LB_ARN=$(aws elbv2 describe-load-balancers --names "${var.environment}-alb" --query "LoadBalancers[0].LoadBalancerArn" --output text)
      while [[ "$(aws elbv2 describe-load-balancers --load-balancer-arns $LB_ARN --query "LoadBalancers[0].State.Code" --output text)" != "active" ]]; do
        echo "Waiting for ALB to be active..."
        sleep 10
      done
      echo "ALB is now active!"
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

