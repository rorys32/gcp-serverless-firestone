output "project_id" { value = google_project.bjj_project.project_id }
output "region" { value = var.region }
output "vpc_names" { value = [for vpc in google_compute_network.vpc : vpc.name] }