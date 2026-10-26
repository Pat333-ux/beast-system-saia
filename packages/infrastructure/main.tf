terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

variable "gcp_project_id" {
  type        = string
  description = "Google Cloud Project ID for BEAST-SAIA"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "GCP deployment region"
}

# Cloud SQL PostgreSQL Instance for BEAST-SAIA platform state
resource "google_sql_database_instance" "postgres_instance" {
  name             = "beast-saia-db-instance"
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false
}

# Cloud Run Service for Submission Gateway
resource "google_cloud_run_v2_service" "submission_gateway" {
  name     = "submission-gateway"
  location = var.gcp_region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "gcr.io/${var.gcp_project_id}/submission-gateway:latest"
      
      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }
}

output "service_url" {
  value       = google_cloud_run_v2_service.submission_gateway.uri
  description = "Public endpoint URL for the BEAST-SAIA Submission Gateway Cloud Run service"
}
