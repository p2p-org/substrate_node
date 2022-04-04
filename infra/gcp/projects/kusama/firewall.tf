locals {
## Ip addresses from which you have an access via ssh etc
  trusted = [
    "1.1.1.1/32",
    "2.2.2.2/32"
  ]

  firewalls = {
    kusama_node = [
      "ssh",
      "p2p",
      "rpc",
      "ws",
    ],
    kusama_validator = [
      "ssh",
      "p2p"
    ],
    kusama_validator_pruned = [
      "ssh",
      "p2p"
    ]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = local.trusted
  target_tags = ["ssh"]
}

resource "google_compute_firewall" "p2p" {
  name    = "p2p"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30333"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["p2p"]
}

resource "google_compute_firewall" "rpc" {
  name    = "rpc"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9933"]
  }

  source_ranges = local.trusted
  target_tags = ["rpc"]
}

resource "google_compute_firewall" "ws" {
  name    = "ws"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9944"]
  }

  source_ranges = local.trusted
  target_tags = ["ws"]
}
