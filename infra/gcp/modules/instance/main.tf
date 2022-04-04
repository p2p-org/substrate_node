resource "google_compute_address" "external_ip" {
  name               = "${var.instance_name}-ext-ip"
  address_type       = "EXTERNAL"
  region             = var.region

  lifecycle {
    ignore_changes   = [ region ]
  }
}

resource "google_compute_disk" "extended_disk" {
  count              = var.extended_disk_size > 0 ? 1 : 0
  name               = "${var.instance_name}-disk-1"
  type               = var.extended_disk_type
  zone               = var.zone
  size               = var.extended_disk_size
  snapshot           = var.snapshot_name

  labels = {
    disk_name        = "${var.instance_name}-disk-1"
  }

  lifecycle {
    ignore_changes   = [ zone, snapshot ]
  }
}

resource "google_compute_attached_disk" "default" {
  count              = var.extended_disk_size > 0 ? 1 : 0
  device_name        = "${var.instance_name}-disk-1"
  disk               = google_compute_disk.extended_disk[0].id
  instance           = google_compute_instance.instance.id

  lifecycle {
    ignore_changes   = [ zone ]
  }
}

resource "google_compute_instance" "instance" {
  name               = var.instance_name
  machine_type       = var.instance_type
  zone               = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image          = var.boot_disk_image
      size           = var.boot_disk_size
    }
  }

  tags               = var.firewall
  
  can_ip_forward = var.can_ip_forward

  network_interface {
    network          = "default"
    access_config {
      nat_ip         = google_compute_address.external_ip.address
    }
  }

  metadata = {
    ssh-keys = join("\n", [for row in var.ssh_public_keys : "${var.ssh_user}:${row}"])
  }
  
  lifecycle {
    ignore_changes   = [zone,attached_disk]
  }
}
