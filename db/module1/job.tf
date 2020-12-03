resource "kubernetes_job" "demo" {
  wait_for_completion = true
  metadata {
    name = "tf-job"
  }
  spec {
    
    completions = 7
    backoff_limit = 8
    active_deadline_seconds = 5
    ttl_seconds_after_finished = 1

    template {
      metadata {}
      spec {
        container {
          name    = "pi"
          image   = "perl"
          command = ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
        }
        restart_policy = "Never"
      }
    }
  }
}