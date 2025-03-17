# Deploys the BJJGameBuilder app using reusable modules
module "cloud_run" {
  source          = "../../modules/cloud-run-service"
  service_name    = "bjj-game-builder"
  region          = var.region
  container_image = "gcr.io/${var.project_id}/bjj-game-builder:latest"  # Placeholder until CI/CD builds it
}

module "firestore" {
  source          = "../../modules/firestore-database"
  project_id      = var.project_id
  region          = var.region
  collection_name = "bjj-game-builder"
}