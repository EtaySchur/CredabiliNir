resource "kubernetes_daemonset" "example" {
  metadata {
    name      = "tf-daemonset"
    namespace = "something"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    strategy {
      type = "RollingUpdate"
      rolling_update  {
          max_unavailable = 2
      }
    }

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    min_ready_seconds = 12
    revision_history_limit = 1


    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        active_deadline_seconds = 1
        automount_service_account_token = false
        dns_policy = "None"
        host_ipc = false
				host_pid = true
				host_network = true
        enable_service_links = false

        host_aliases {
          hostnames = ["some-name"]
          ip = "some-ip"
        }

        hostname = "some-host-name"
        node_name = "node-name"

        node_selector = {
          "diskType" = "ssd"
        }

        image_pull_secrets {
          name = "application"
        }

        dns_config {
          nameservers = ["1.2.3.4"]
          searches = ["ns1.svc.cluster-domain.example", "my.dns.search.suffix"]
          option {
            name = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        init_container {
          name = "myapp-container"
          image = "busybox:1.28"
          command = [ "sh", "-c", "echo the app is running! && sleep 3600" ]
        }

        container {
          image = "nginx:1.7.8"
          name  = "example"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

        }

          priority_class_name = "system-node-critical"
        restart_policy = "Always"

        security_context {
          run_as_group = 1
          run_as_user = 1
          fs_group = 1
          run_as_non_root = false
        }

        service_account_name = "default"
        share_process_namespace = false

        subdomain = "sub"
        termination_grace_period_seconds = 10

        toleration {
          key = "example-key"
          operator = "Exists"
          effect = "NoSchedule"
        }


        volume {
          name = "test-volume"
          aws_elastic_block_store {
            volume_id = "some-volume-id"
            fs_type = "ext4"
          }
        }

        volume {
          name = "config-volume"
          config_map {
            name = "log-config"
            items {
              key = "log_level"
              path = "log_level"
            }
          }
        }
      }
    }
  }
}