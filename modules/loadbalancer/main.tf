# target pool
resource "google_compute_target_pool" "main" {
  name          = "kube-cluster-pool"
  instances     = local.instances
  health_checks = [google_compute_health_check.tcp.name]
}

# health check
resource "google_compute_health_check" "tcp" {
  count = length(local.health_check_ports)
  name  = "tcp-health-check-${80}"
  tcp_health_check {
    port = 80
  }
}

# forwarding rule
resource "google_compute_forwarding_rule" "main" {
  name                  = "kube-lb"
  ip_protocol           = "TCP"
  port_range            = var.ports[0]
  target                = google_compute_target_pool.main.id
  load_balancing_scheme = "EXTERNAL"
  # allow_global_access   = true
}
