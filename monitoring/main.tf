resource "helm_release" "prometheus" {
  create_namespace = true
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
 // version    = "15.2.1" # Ensure this matches the version you want
  values = [templatefile("${var.environment}/values_prom.yaml", {
    DESTINATION_GMAIL_ID   = var.DESTINATION_GMAIL_ID
    SOURCE_AUTH_PASSWORD   = var.SOURCE_AUTH_PASSWORD
    SOURCE_GMAIL_ID        = var.SOURCE_GMAIL_ID
  })]
}


resource "helm_release" "grafana" {
  create_namespace = true
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
 // version    = "15.2.1" # Ensure this matches the version you want
  values = [
    file("${var.environment}/values_grafana.yaml") # Path to your custom values file
  ]
  set {
    name  = "adminPassword"
    value = "admin"
  }
}



