# Build and push Docker image
resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.app_source_path} &&
      docker build -t ${var.container_image} . &&
      docker push ${var.container_image}
    EOT
  }
}

# Deploy to Cloud Run using the module
module "cloud_run" {
  source          = "../../modules/cloud-run-service"
  service_name    = var.app_name
  region          = var.region
  container_image = var.container_image
  container_port  = var.container_port
  env_vars        = var.env_vars
  depends_on      = [null_resource.build_and_push]
}

# Output for app4
output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = module.cloud_run.service_url
}