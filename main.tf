# Main configuration for the GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}