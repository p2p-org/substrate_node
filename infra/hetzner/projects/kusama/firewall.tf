locals {
## Ip addresses from which you have an access via ssh etc
  trusted = [
    "1.1.1.1/32",
    "2.2.2.2/32"
  ]

  private_networks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  firewalls = {
    kusama_node      =  [ hcloud_firewall.kusama_node.id ], 
    kusama_validator_pruned =  [ hcloud_firewall.kusama_validator.id ]
  }
}

resource "hcloud_firewall" "kusama_node" {
  name = "kusama_node"
  rule {
   direction  = "in"
   port       = 22
   protocol   = "tcp"
   source_ips = local.trusted
  }

  rule {
   direction  = "in"
   port       = 30333
   protocol   = "tcp"
   source_ips = [ "0.0.0.0/0" ]
  }
 
  rule {
   direction  = "in"
   port       = 9933
   protocol   = "tcp"
   source_ips = local.trusted
  }

  rule {
   direction  = "in"
   port       = 9944
   protocol   = "tcp"
   source_ips = local.trusted
  }
}

resource "hcloud_firewall" "kusama_validator" {
  name = "kusama_validator"
  rule {
   direction  = "in"
   port       = 22
   protocol   = "tcp"
   source_ips = local.trusted
  }

  rule {
   direction  = "in"
   port       = 30333
   protocol   = "tcp"
   source_ips = [ "0.0.0.0/0" ]
  }
}
