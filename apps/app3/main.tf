# Explicitly define the Google provider for this module
provider "google" {
  project = var.project_id
  region  = var.region
}

# Build and push Docker image to Google Container Registry (GCR)
resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.app_source_path} &&
      docker build -t gcr.io/${var.project_id}/${var.app_name}:latest . &&
      docker push gcr.io/${var.project_id}/${var.app_name}:latest
    EOT
  }
}

# Deploy to Cloud Run using the existing module
module "cloud_run" {
  source          = "../../modules/cloud-run-service"
  service_name    = var.app_name
  region          = var.region
  container_image = "gcr.io/${var.project_id}/${var.app_name}:latest"
  depends_on      = [null_resource.build_and_push]
}

# Optional Firestore setup for future Node.js/Express support
module "firestore" {
  source         = "../../modules/firestore-database"
  project        = var.project_id
  location_id    = var.region
  collection     = "${var.app_name}-data"
}