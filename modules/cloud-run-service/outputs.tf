output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.service.status[0].url
}