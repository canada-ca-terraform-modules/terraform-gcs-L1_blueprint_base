resource "google_compute_firewall" "project_firewall" {
  for_each = var.firewall

  name        = each.key
  description = try(each.value.description, null)
  network     = google_compute_network.vpc_network.name

  dynamic "allow" {
    for_each = try(each.value.allow, [])
    content {
      protocol = allow.key
      ports    = try(allow.value.ports, null)
    }
  }

  dynamic "deny" {
    for_each = try(each.value.deny, [])
    content {
      protocol = deny.key
      ports    = try(deny.value.ports, null)
    }
  }

  priority  = try(each.value.priority, null)
  direction = try(each.value.direction, "INGRESS")
  disabled  = try(each.value.disabled, false)

  source_ranges           = try(each.value.source_ranges, null)
  destination_ranges      = try(each.value.destination_ranges, null)
  source_service_accounts = try(each.value.source_service_accounts, null)
  source_tags             = try(each.value.source_tags, null)
  target_service_accounts = try(each.value.target_service_accounts, null)
  target_tags             = try(each.value.target_tags, null)
}
