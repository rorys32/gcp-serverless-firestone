resource "google_storage_bucket" "bjj_game_builder" {
  name          = var.bucket_name
  location      = var.region
  project       = var.project_id
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  uniform_bucket_level_access = true
  depends_on = [google_project_service.storage_api]
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.bjj_game_builder.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "null_resource" "clone_and_upload" {
  provisioner "local-exec" {
    command = <<EOT
      git clone ${var.bjj_repo_url} bjj_temp &&
      cd bjj_temp &&
      gsutil cp -r * gs://${google_storage_bucket.bjj_game_builder.name}/ &&
      cd .. && rm -rf bjj_temp
    EOT
  }
  depends_on = [google_storage_bucket.bjj_game_builder]
}