locals {
  deployListVMs = {
    for x in var.VMs :
    "${x.serverType}-${x.userDefinedString}${x.postfix}" => x if lookup(x, "deploy", true) != false
  }
}

# resource "google_service_account" "default" {
#   account_id   = "service-account-id"
#   display_name = "Service Account"
# }

data "google_service_account" "tfadmin" {
  account_id = "tfadmin-${var.project}"
}

module "project_vms" {
  # source = "/home/bernard/github/modules/terraform-gcs-caf-virtual_machine"
  source = "github.com/canada-ca-terraform-modules/terraform-gcs-caf-virtual_machine?ref=v0.1.1"
  # version = "~> v0.0.1"

  for_each          = local.deployListVMs
  env               = var.env
  serverType        = each.value.serverType
  userDefinedString = each.value.userDefinedString
  postfix           = each.value.postfix
  machine_type      = each.value.machine_type
  disks             = try(each.value.disks, {})
  zone              = try(each.value.zone, "northamerica-northeast1-a")
  tags              = try(each.value.tags, null)
  initialize_params = each.value.initialize_params
  network_interface = {
    subnetwork    = google_compute_subnetwork.compute_subnetwork[each.value.network_interface.subnetwork]
    access_config = try(each.value.network_interface.public_ip, null)
    network_ip    = try(each.value.network_interface.network_ip, null)
  }
  metadata_startup_script = try(each.value.metadata_startup_script, "")
  service_account = {
    email  = try(each.value.service_account.email, data.google_service_account.tfadmin.email)
    scopes = try(each.value.service_account.scopes, ["cloud-platform"])
  }
  metadata = try(each.value.metadata, {})
}

# resource "google_compute_instance" "default" {
#   name         = "test"
#   machine_type = "e2-micro"
#   zone         = "northamerica-northeast1-a"

#   tags = ["foo", "bar"]

#   allow_stopping_for_update = true

#   boot_disk {
#     initialize_params {
#       image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220204"
#       size  = 10
#       type  = "pd-balanced"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.compute_subnetwork["maz"].name

#     #access_config {
#     #  // Ephemeral public IP
#     #}
#   }

#   metadata = {
#     foo = "bar"
#   }

#   # metadata_startup_script = "echo hi > /test.txt"

#   service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]
#   }
# }
