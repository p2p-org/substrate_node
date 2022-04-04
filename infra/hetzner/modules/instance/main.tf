terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

resource "hcloud_floating_ip" "external_ip" {
  count            = var.floating_ip == "yes" ? 1 : 0
  type             = "ipv4"
  home_location    = var.region

  lifecycle {
    ignore_changes = [ home_location ]
  }
}

resource "hcloud_volume" "extended_disk" {
  count            = var.extended_disk_size > 0 ? 1 : 0
  name             = "${var.instance_name}-disk-1"
  location         = var.region
  size             = var.extended_disk_size

  lifecycle {
    ignore_changes = [ location ]
  }
}

resource "hcloud_floating_ip_assignment" "default" {
  count            = var.floating_ip == "yes" ? 1 : 0
  floating_ip_id   = hcloud_floating_ip.external_ip.0.id
  server_id        = hcloud_server.instance.id
}

resource "hcloud_volume_attachment" "default" {
  count            = var.extended_disk_size > 0 ? 1 : 0
  volume_id        = hcloud_volume.extended_disk[0].id
  server_id        = hcloud_server.instance.id
  automount        = true
}

resource "hcloud_server_network" "default" {
  server_id        = hcloud_server.instance.id
  subnet_id        = var.network
} 

resource "hcloud_server" "instance" {
  name             = var.instance_name
  image            = var.boot_disk_image
  server_type      = var.instance_type
  datacenter       = var.zone
  keep_disk        = true
  ssh_keys         = var.ssh_key 
  
  firewall_ids     = var.firewall
  lifecycle {
    ignore_changes = [ datacenter, ssh_keys ]
  }
}
