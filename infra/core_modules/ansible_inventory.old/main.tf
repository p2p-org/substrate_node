resource "local_file" "ansible_inventory" {
  for_each = { 
  for k,v in var.instances : k => v...
  }
  
  content  = templatefile("${path.module}/inventory.tmpl",
  { 
    instances       = each.value
    prefix          = var.prefix
    roles           = var.roles
    baskets         = var.baskets
    regions         = var.regions
    disks           = var.disks
    telemetry_names = var.telemetry_names
    module          = var.module
    inventory_name  = each.key
   })

  filename = "../../../../inventory/${var.project}/${var.prefix}-${each.key}.yml"
}
