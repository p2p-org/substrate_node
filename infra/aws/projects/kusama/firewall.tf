locals {
## Ip addresses from which you have an access via ssh etc
  trusted = [
    "1.1.1.1/32", 
    "2.2.2.2/32" 
  ]

## Mapping security groups
  firewalls = {
    kusama_node = [ aws_security_group.kusama_node.id ],
    kusama_validator_pruned = [ aws_security_group.kusama_validator_pruned.id ],
    kusama_validator = [ aws_security_group.kusama_validator.id ]
  }
}

resource "aws_security_group" "kusama_node" {
  name   = "kusama_node rules set"
  vpc_id = aws_vpc.localnet.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = local.trusted
  }

  ingress {
    description      = "RPC"
    from_port        = 9933
    to_port          = 9933
    protocol         = "tcp"
    cidr_blocks      = local.trusted
  }

  ingress {
    description      = "WS"
    from_port        = 9944
    to_port          = 9944
    protocol         = "tcp"
    cidr_blocks      = local.trusted
  }

  ingress {
    description      = "p2p"
    from_port        = 30333
    to_port          = 30334
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "kusama_validator_pruned" {
  name   = "kusama_validator_pruned rules set"
  vpc_id = aws_vpc.localnet.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = local.trusted
  }

  ingress {
    description      = "p2p"
    from_port        = 30333
    to_port          = 30334
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
