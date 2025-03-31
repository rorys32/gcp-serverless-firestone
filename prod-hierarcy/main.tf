provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
}

resource "google_project" "bjj_project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

resource "google_project_service" "storage_api" {
  project = google_project.bjj_project.project_id
  service = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_api" {
  project = google_project.bjj_project.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

# VPCs for Prod, Non-Prod, Dev
resource "google_compute_network" "vpc" {
  for_each                = toset(["prod", "non-prod", "dev"])
  name                    = "${each.key}-vpc"
  auto_create_subnetworks = false
  project                 = google_project.bjj_project.project_id
}

# Two subnets per VPC in different regions
resource "google_compute_subnetwork" "subnet" {
  for_each = {
    "prod-us-central1"    = { vpc = "prod", region = "us-central1", cidr = "10.0.0.0/24" },
    "prod-us-east1"       = { vpc = "prod", region = "us-east1",   cidr = "10.0.1.0/24" },
    "non-prod-us-central1"= { vpc = "non-prod", region = "us-central1", cidr = "10.1.0.0/24" },
    "non-prod-us-east1"   = { vpc = "non-prod", region = "us-east1",   cidr = "10.1.1.0/24" },
    "dev-us-central1"     = { vpc = "dev", region = "us-central1", cidr = "10.2.0.0/24" },
    "dev-us-east1"        = { vpc = "dev", region = "us-east1",   cidr = "10.2.1.0/24" }
  }
  name          = "${each.key}"
  ip_cidr_range = each.value.cidr
  region        = each.value.region
  network       = google_compute_network.vpc[each.value.vpc].id
  project       = google_project.bjj_project.project_id
}