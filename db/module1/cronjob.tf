resource "kubernetes_cron_job" "demo" {
  metadata {
    name = "tf-cronjob"
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "1 0 * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {}
      spec {
        active_deadline_seconds = 1
        backoff_limit = 8
        completions = 1
        manual_selector = false
        parallelism = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {}
          spec {
            active_deadline_seconds = 1

            container {
              name    = "hello"
              image   = "busybox"
              command = ["/bin/sh", "-c", "date; echo Hello from the Kubernetes cluster"]
            }
          }
        }
      }
    }
  }
}