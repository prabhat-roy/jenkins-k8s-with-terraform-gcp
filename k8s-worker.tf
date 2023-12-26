
# Create a single Compute Engine instance
resource "google_compute_instance" "k8s-worker" {
  name         = "k8s-worker"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["k8s-worker"]
  boot_disk {
    initialize_params {
      size = "10"
      image = var.k8s_image
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.public-key)}"
  }
  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      nat_ip = google_compute_address.k8s-worker.address
    }
  }
}
/*
resource "null_resource" "k8s-worker" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.k8s-worker.address
  }
  provisioner "file" {
    source      = "k8s-worker.sh"
    destination = "/tmp/k8s-worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s-worker.sh",
      "sh /tmp/k8s-worker.sh",
    ]
  }

  depends_on = [
    google_compute_instance.k8s-worker
  ]
}
*/