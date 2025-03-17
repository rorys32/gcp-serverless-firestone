# Outputs for root-level configuration
output "project_id" {
  description = "The configured GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "The configured GCP region"
  value       = var.region
}