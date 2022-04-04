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

  zones = [
    "fr-par-1",
    "fr-par-2",
    "nl-ams-1",
    "pl-waw-1"
  ]

  firewalls = {
    moonriver_node = { for k in scaleway_instance_security_group.moonriver_node : k.zone => k.id},
    moonriver_collator = { for k in scaleway_instance_security_group.moonriver_collator : k.zone => k.id}
  }
}

resource "scaleway_instance_security_group" "moonriver_node" {
  name                    = "moonriver_node[${each.value}]"
  description             = "moonriver_node SG"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  for_each                = { for zone in local.zones:  zone => zone }
  zone                    = each.value

  # Allow all ports for private nerworks
  dynamic "inbound_rule" {
    for_each =  local.private_networks
    content {
      action   = "accept"
      protocol = "ANY"
      ip_range = inbound_rule.value
    }
  }

  # Allow all ports for trusted IPs list
  dynamic "inbound_rule" {
    for_each = local.trusted
    content {
      action   = "accept"
      port     = 22
      protocol = "TCP"
      ip       = inbound_rule.value
    }
  }

  inbound_rule {
      action   = "accept"
      port     = 30333
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 30334
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 9934
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 9945
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 443
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }
}

resource "scaleway_instance_security_group" "moonriver_collator" {
  name                    = "moonriver_collator[${each.value}]"
  description             = "moonriver_collator SG"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  for_each                = { for zone in local.zones:  zone => zone }
  zone                    = each.value

  # Allow all ports for private nerworks
  dynamic "inbound_rule" {
    for_each =  local.private_networks
    content {
      action   = "accept"
      protocol = "ANY"
      ip_range = inbound_rule.value
    }
  }

  # Allow all ports for trusted IPs list
  dynamic "inbound_rule" {
    for_each = local.trusted
    content {
      action   = "accept"
      port     = 22
      protocol = "TCP"
      ip       = inbound_rule.value
    }
  }

  inbound_rule {
      action   = "accept"
      port     = 30333
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 30334
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }

  inbound_rule {
      action   = "accept"
      port     = 9945
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
  }
}
