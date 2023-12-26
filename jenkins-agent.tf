
# Create a single Compute Engine instance for Jenkins Agent
resource "google_compute_instance" "jenkins-agent" {
  name         = "jenkins-agent"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["jenkins-agent"]
  boot_disk {
    initialize_params {
      size = "20"
      image = var.vm_image
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.public-key)}"
  }
  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      nat_ip = google_compute_address.jenkins-agent.address
    }
  }
}
/*
resource "null_resource" "jenkins-agent" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.jenkins-agent.address
  }
  provisioner "file" {
    source      = "jenkins-agent.sh"
    destination = "/tmp/jenkins-agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins-agent.sh",
      "sh /tmp/jenkins-agent.sh",
    ]
  }

  depends_on = [
    google_compute_instance.jenkins-agent
  ]
}
*/