provider "google" {
  credentials = file("gcp_credentials.json")
  project     = var.GCP_PROJECT_ID
  region      = var.GCP_REGION
  zone        = var.GCP_ZONE
}

resource "google_project_service" "api" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  disable_on_destroy = false
  service            = each.value
}

resource "google_compute_firewall" "web" {
  name          = "web-access"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_instance" "web-server" {
  name         = "web-server"
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = <<EOF
  #!/bin/sh
  apt update -y
  apt install apache2 -y
  echo "<h2>WebServer on GCP Build by Terraform!<h2>"  >  /var/www/html/index.html
  systemctl restart apache2
  EOF

  depends_on = [
    google_project_service.api,
    google_compute_firewall.web
  ]
}
