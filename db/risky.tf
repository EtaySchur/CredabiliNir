resource "kubernetes_deployment" "risky_redis_deployment" {
  metadata {
    name      = "risky-redis-deployment-tf"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "web"
      }
    }

    template {
      metadata {
        labels = {
          app = "web"
        }
      }

      spec {
        volume {
          name = "risky-volume"

          host_path {
            path = "/var/run/docker.sock"
          }
        }


        container {
          name  = "risky-redis-container"
          image = "redis:latest"

          port {
            name           = "redis"
            host_port      = 6379
            container_port = 6379
            protocol       = "TCP"
          }

          env_from {
            secret_ref {
              name = "risky-secret"
            }
          }

          env {
            name = "MY_DB_PW"

            value_from {
              secret_key_ref {
                name = "risky-secret"
                key  = "PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "risky-volume"
            mount_path = "/mnt/risky"
          }

          image_pull_policy = "Never"

          security_context {
            capabilities {
              add = ["SYS_ADMIN", "NET_ADMIN", "NET_RAW"]
            }

            privileged                 = true
            allow_privilege_escalation = true
          }
        }

        container {
          name  = "some-second-container"
          image = "mysql"
        }

        service_account_name            = "default"
        automount_service_account_token = true
        host_network                    = true
        host_pid                        = true
        host_ipc                        = true
      }
    }
  }
}

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
        security_context {
          run_as_non_root = var.run_as_non_root
        }
        container {
          image             = "ngnix"
          name              = "tfvars-ngnix-container"
          image_pull_policy = "Always"
          resources {
            requests {
              cpu    = 34
              memory = 78
            }
          }
        }
      }
    }
  }
}

