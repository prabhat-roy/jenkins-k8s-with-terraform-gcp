
# Create a single Compute Engine instance for Jenkins Master
resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["jenkins"]
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.public-key)}"
  }
  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      nat_ip = google_compute_address.jenkins.address
    }
  }
}
/*
resource "null_resource" "jenkins" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.jenkins.address
  }
  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins.sh",
      "sh /tmp/jenkins.sh",
    ]
  }

  depends_on = [
    google_compute_instance.jenkins
  ]
}
*/