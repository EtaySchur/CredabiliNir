provider "kubernetes" {}

resource "kubernetes_deployment" "risky" {
  metadata {
    name = "risky-redis-deployment-hc"
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
				host_ipc = true
				host_pid = true
				host_network = true
        container {
          image = "redis:latest"
          name  = "risky-redis-container"
					image_pull_policy = "Never"
        }
      }
    }
  }
}
