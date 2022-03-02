provider "google" {
  # alias   = "gcp-provider"
  region  = var.default_region
  project = var.project_name
}