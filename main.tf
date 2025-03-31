# Main configuration for the GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "storage_api" {
  project = var.project_id
  service = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container_registry_api" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

# Dummy resource to ensure provider context and outputs are set
resource "google_storage_bucket" "dummy" {
  name                          = "${var.project_id}-dummy-${var.app_name}"
  location                      = var.region
  force_destroy                 = true
  uniform_bucket_level_access   = true  # Added to comply with UBLA constraint
}