locals {
  ssh_public_keys = {
    user1 = "public key"
    user2 = "public key"
    user3 = "public key"
  }
}

resource "scaleway_account_ssh_key" "default" {
  for_each   = { for k,v in local.ssh_public_keys: k => v }
  name       = each.key
  public_key = each.value
}
