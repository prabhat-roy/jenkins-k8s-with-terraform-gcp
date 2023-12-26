
resource "google_compute_address" "jenkins" {
  name    = "jenkins-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "jenkins-agent" {
  name    = "jenkins-agent-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "nexus" {
  name    = "nexus-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "k8s-master" {
  name    = "k8s-master-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "k8s-worker" {
  name    = "k8s-worker-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "sonar" {
  name    = "sonar-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "tomcat" {
  name    = "tomcat-public-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "wazuh" {
  name    = "wazuh-public-ip"
  project = var.project_id
  region  = var.region
}
