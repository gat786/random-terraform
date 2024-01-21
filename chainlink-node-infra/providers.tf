terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.12.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }

  }

  backend "gcs" {
    bucket = "testing-infra-state"
    prefix = "chainlink-node-infra"
  }
}

provider "google" {
  project = "trantor-test-379409"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}
