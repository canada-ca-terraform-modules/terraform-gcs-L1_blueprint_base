resource "google_compute_network" "vpc_network" {
  name                            = "${var.project_name}-vpc"
  auto_create_subnetworks         = try(var.network.vpc.auto_create_subnetworks, false)
  routing_mode                    = try(var.network.vpc.routing_mode, null)
  project                         = try(var.network.vpc.project_id, null)
  description                     = try(var.network.vpc.description, null)
  delete_default_routes_on_create = try(var.network.vpc.delete_default_internet_gateway_routes, null)
  mtu                             = try(var.network.vpc.mtu, null)
}

resource "google_compute_subnetwork" "compute_subnetwork" {
  for_each = var.network.subnets

  name                     = "${google_compute_network.vpc_network.name}-${each.key}"
  ip_cidr_range            = each.value.ip_cidr_range
  network                  = google_compute_network.vpc_network.id
  region                   = try(each.value.region, null)
  private_ip_google_access = try(each.value.private_ip_google_access, null)
  project                  = try(each.value.project, null)
  description              = try(each.value.description, null)
  purpose                  = try(each.value.purpose, null)
  role                     = try(each.value.role, null)

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config", false) ? [{
      aggregation_interval = lookup(each.value, "aggregation_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(each.value, "flow_sampling", "0.5")
      metadata             = lookup(each.value, "metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }
}
