locals {
  ssh_keys = [ for key in hcloud_ssh_key.default: key.id ] 

  ssh_public_keys = {
    user1  = "public key",
    user2 = "public key"
  }
}

resource "hcloud_ssh_key" "default" {
  for_each   = { for k,v in local.ssh_public_keys: k => v }
  name       = each.key
  public_key = each.value
}
