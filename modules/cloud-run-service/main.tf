resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  template {
    spec {
      containers {
        image = var.container_image
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}