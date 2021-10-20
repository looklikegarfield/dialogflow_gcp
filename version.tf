terraform {
  required_version = ">= 1.0.7"
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      #version = "3.5.0"
      version = "~> 3.87.0"
    }
  }
}

provider "google" {
  access_token = var.access_token

  project = var.project_id
  region  = "us-west2"
}
