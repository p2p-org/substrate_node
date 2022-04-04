module "instance" {
  source             = "./modules/instance"

  for_each = {
      for item in local.config : item.instance_name => item
  }

  zone               = each.value.zone
  region             = each.value.region

  instance_name      = each.key
  instance_type      = each.value.instance_type

  snapshot_name      = var.snapshot_name

  boot_disk_size     = each.value.boot_disk_size
  boot_disk_image    = each.value.boot_disk_image

  extended_disk_size = each.value.extended_disk_size
  extended_disk_type = each.value.extended_disk_type

  floating_ip        = each.value.floating_ip

  firewall           = try(local.firewalls[each.value.type], null)
  network            = hcloud_network_subnet.main.id

  ssh_key            = local.ssh_keys
}

module "ansible_inventory" {
  source             = "./modules/ansible_inventory/"
  inventory_path     = var.inventory_path
  instances          = local.instances
  module             = module.instance
  prefix             = local.prefix
  project            = local.project
  regions            = local.regions
  disks              = local.disks
  vars               = local.vars
  vars_list          = local.vars_list
  vars_nested        = local.vars_nested
}
