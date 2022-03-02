data "google_compute_network" "core_vpc_network" {
  count = try(var.deployOptionalFeatures.vdc_peering, false) ? 1 : 0

  name = var.optionalFeatures.vdc_peering.core_vdc_vpc_name
  project = var.optionalFeatures.vdc_peering.core_vdc_project_name
}

resource "google_compute_network_peering" "project_vdc" {
  count = try(var.deployOptionalFeatures.vdc_peering, false) ? 1 : 0

  name         = "project-vdc"
  network      = google_compute_network.vpc_network.self_link
  peer_network = data.google_compute_network.core_vpc_network[0].self_link
}

resource "google_compute_network_peering" "core_vdc" {
  count = try(var.deployOptionalFeatures.vdc_peering, false) ? 1 : 0

  name         = "core-vdc"
  network      = data.google_compute_network.core_vpc_network[0].self_link
  peer_network = google_compute_network.vpc_network.self_link
}