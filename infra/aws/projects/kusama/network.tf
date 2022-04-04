locals {
  subnets = {
    "eu-central-1a" = "192.168.1.0/24",
    "eu-central-1b" = "192.168.2.0/24",
    "eu-central-1c" = "192.168.3.0/24"
  }
}

resource "aws_vpc" "localnet" {
  cidr_block              = "192.168.0.0/16"

  enable_dns_hostnames    = false

  enable_dns_support      = true
}

resource "aws_subnet" "main" {
  for_each = { for k,v in local.subnets: k => v }

  availability_zone       = each.key
  cidr_block              = each.value

  vpc_id                  = aws_vpc.localnet.id

  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main" {
  vpc_id                  = aws_vpc.localnet.id
}

resource "aws_route_table" "main" {
  vpc_id                  = aws_vpc.localnet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  for_each = { for k,v in local.subnets: k => v }
  subnet_id              = aws_subnet.main[each.key].id
  route_table_id         = aws_route_table.main.id
}
