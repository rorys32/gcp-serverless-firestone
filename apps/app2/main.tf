# Provider configuration for standalone execution
provider "google" {
  project = var.project_id
  region  = var.region
}

# Deploys the BJJGameBuilder app using reusable modules
module "cloud_run" {
  source          = "../../modules/cloud-run-service"
  service_name    = "bjj-game-builder"
  region          = var.region
  container_image = "gcr.io/${var.project_id}/bjj-game-builder:latest"  # Placeholder until CI/CD builds it
}

module "firestore" {
  source         = "../../modules/firestore-database"
  project        = var.project_id      # Matches module var "project"
  location_id    = var.region          # Matches module var "location_id"
  collection     = "bjj-game-builder"  # Matches module var "collection"
}