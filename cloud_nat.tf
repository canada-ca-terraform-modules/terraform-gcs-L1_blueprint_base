resource "google_compute_router_nat" "project_router_nat" {
  name                               = "${var.project_name}-nat"
  router                             = google_compute_router.project-router.name
  region                             = google_compute_router.project-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  log_config {
    enable = false
    filter = "ALL"
  }
}