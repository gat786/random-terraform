resource "google_sql_database_instance" "node-db" {
  name             = var.database_instance_name
  database_version = "POSTGRES_15"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier      = var.database_instance_tier
    disk_size = var.database_instance_disk_size
  }
}

resource "random_password" "password" {
  length           = 16
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_sql_user" "root_user" {
  name      = var.database_user_name
  instance  = google_sql_database_instance.node-db.name
  password  = random_password.password.result
}

resource "google_service_account" "default" {
  account_id   = var.compute_instance_sa_name
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = var.compute_instance_name
  machine_type = var.compute_instance_machine_type

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_secret_manager_secret" "chainlink-node-db-password" {
  secret_id = "chainlink-node-db-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "chainlink-node-db-password" {
  secret = google_secret_manager_secret.chainlink-node-db-password.id
  secret_data = random_password.password.result
}


output "database_password" {
  value     = random_password.password.result
  # this is because I want to see the value in the output
  # normally you would have it set to true
  sensitive = true
}
