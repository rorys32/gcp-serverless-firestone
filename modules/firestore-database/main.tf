# Create (default) database only if it doesn’t exist; manage cautiously
resource "google_firestore_database" "database" {
  project     = var.project
  name        = "(default)"
  location_id = "us-central1"  # Hardcode to match project region; adjust if needed
  type        = "FIRESTORE_NATIVE"

  # Prevent recreation or updates if already exists
  lifecycle {
    create_before_destroy = true  # Ensure new database creation doesn’t conflict
    ignore_changes        = [name, location_id, type]  # Ignore if exists
  }
}

# Create app-specific collection in the (default) database
resource "google_firestore_document" "initial_collection" {
  project     = var.project
  collection  = var.collection
  document_id = "init"
  fields      = jsonencode({ "initialized" = { "booleanValue" = true } })
  depends_on  = [google_firestore_database.database]
}