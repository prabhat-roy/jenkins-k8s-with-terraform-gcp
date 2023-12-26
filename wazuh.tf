
# Create a single Compute Engine instance
resource "google_compute_instance" "wazuh" {
  name         = "wazuh"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["wazuh"]
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
      nat_ip = google_compute_address.wazuh.address
    }
  }
}
/*
resource "null_resource" "wazuh" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.wazuh.address
  }
  provisioner "file" {
    source      = "wazuh.sh"
    destination = "/tmp/wazuh.sh"
  }

  provisioner "remote-exec" {
    inline = [

      "sudo chmod +x /tmp/wazuh.sh",
      "sh /tmp/wazuh.sh",
    ]
  }

  depends_on = [
    google_compute_instance.wazuh
  ]
}
*/