resource "google_compute_router" "project-router" {
  name    = "${var.project_name}-router"
  # region  = google_compute_subnetwork.compute_subnetwork["maz"].region
  network = google_compute_network.vpc_network.id

#   bgp {
#     asn = 64514
#   }
}