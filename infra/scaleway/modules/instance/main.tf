terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.0"
    }
  }
}

resource "scaleway_instance_ip" "public_ip" {
  zone = var.zone

  lifecycle {
    ignore_changes = [zone]
  }
}

resource "scaleway_instance_volume" "extended_disk" {
  count            = var.extended_disk_size > 0 ? 1 : 0
  type             = var.extended_disk_type
  name             = "${var.instance_name}-disk-1"
  size_in_gb       = var.snapshot_name != null ? null : var.extended_disk_size
  zone             = var.zone
  from_snapshot_id = var.snapshot_name

  lifecycle {
    ignore_changes = [zone, from_snapshot_id]
#    ignore_changes = [zone, from_snapshot_id, size_in_gb ]
  }
}

resource "scaleway_instance_server" "instance" {
  name  = var.instance_name
  type  = var.instance_type
  image = var.boot_disk_image
  ip_id = split("/", scaleway_instance_ip.public_ip.id)[1]
  zone  = var.zone

  security_group_id = var.firewall

  root_volume {
    size_in_gb            = var.boot_disk_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [zone, additional_volume_ids]
  }

  additional_volume_ids = var.extended_disk_size > 0 ? [scaleway_instance_volume.extended_disk[0].id] : null
}
