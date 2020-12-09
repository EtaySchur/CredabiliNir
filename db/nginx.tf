provider "kubernetes" {}

resource "kubernetes_deployment" "risky" {
  provisioner "local-exec" {
    command = <<EOH
    kubectl -n default patch deployment risky-redis-deployment-hc --patch "$(cat apolicy.risky-redis-deployment-hc.ImagePullPolicy.yaml)"
    EOH
  }

  metadata {
    name      = "risky-ngnix-deployment-hc"
    namespace = "default"
    labels = {
      app = "risky"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "risky"
      }
    }

    template {
      metadata {
        labels = {
          app = "risky"
        }
      }

      spec {
        automount_service_account_token = true
        host_ipc                        = true
        host_pid                        = true
        host_network                    = true
        container {
          image             = "nginx"
          name              = "risky-ngnix-container"
          image_pull_policy = "Never"

          security_context {
            run_as_user     = 1
            run_as_non_root = true
          }
        }
      }
    }
  }
}