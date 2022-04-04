resource "hcloud_network" "localnet" {
  name = "localnet"
  ip_range = "192.168.0.0/8"
}

resource "hcloud_network_subnet" "main" {
  network_id = hcloud_network.localnet.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "192.168.254.0/23"
}
