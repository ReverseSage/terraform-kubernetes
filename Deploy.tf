resource "kubernetes_namespace" "devops" {
  metadata {
    name = "devops"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace = kubernetes_namespace.devops.metadata[0].name
  recreate_pods = true
  force_update = true
 
  set {
  name  = "controller.installPlugins"
  value = "false"
  }

  set {
    name  = "controller.servicePort"
    value = "8080"
  }

  set {
    name  = "controller.admin.password"
    value = "admin"
  }
  
  

  timeout = 120

  depends_on = [kubernetes_namespace.devops]
}

resource "kubernetes_ingress_v1" "jenkins-ingress" {
  metadata {
    name      = "jenkins-ingress"
    namespace = kubernetes_namespace.devops.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = helm_release.jenkins.name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }

   depends_on = [helm_release.jenkins]
}



resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.devops.metadata[0].name

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "adminPassword"
    value = "admin"  
  }
  timeout = 120
  depends_on = [kubernetes_namespace.devops]
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.devops.metadata[0].name

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  timeout = 120
  depends_on = [kubernetes_namespace.devops]
}