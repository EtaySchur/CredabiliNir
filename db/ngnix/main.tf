resource "kubernetes_deployment" "tf-variables-deployment" {
  metadata {
    name      = "tf-variables-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "variables-tf-deployment"
      }
    }

    template {
      metadata {
        labels = {
          app = "variables-tf-deployment"
        }
      }

      spec {
        automount_service_account_token = var.automount_service_account_token
        host_ipc                        = var.host_ipc
        host_pid                        = var.hostPid

        container {
          image             = "ngnix"
          name              = "tfvars-ngnix-container"
          image_pull_policy = "Always"
          security_context {
            run_as_non_root = true
            run_as_user     = 34
          }
        }
      }
    }
  }
}

