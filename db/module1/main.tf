provider "kubernetes" {}

resource "kubernetes_deployment" "risky-plan" {
  metadata {
    name = "risky-redis-deployment-terraform-plan"
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
				automount_service_account_token = var.automount_service_account_token
				host_ipc = var.host_ipc
				host_pid = var.host_pid
				host_network = var.host_network
        container {
          image = "redis:latest"
          name  = "risky-redis-container"
					image_pull_policy = var.image_pull_policy
        }
      }
    }
  }
}
