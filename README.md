# substrate_node #
Compact set of terraform and ansible roles for deploying substrate based node. Compatible with any substrate based nodes.

## Presented as examples ##

### Kusama (relaychain) ###
#### aws ####
1x Archive kusama node
2x Archive kusama validator
2x Pruned kusama validator

#### gcp ####
1x Archive kusama node
2x Archive kusama validator(gcp-kusama-validator2 became as pruned node(imagine - db corrupted and we fixed it by deploy from snapshot with saving sassion keys))
2x Pruned kusama validator

#### Hetzner ####
1x Archive kusama node
2x Pruned kusama validator

### Moonriver (parachain) ###
#### Scaleway ####
1x Archive moonriver node
1x Archive moonriver collator with redefined telemtry_name 

### Compound (Stan-alone substrate based network) ###
#### Scaleway ####
1x Archive compound node
1x Archive compound validator

# How to deploy #
### Manage with cloud infrastructure with using [Terraform](./docs/terraform.md) ###

### Prepare your servers with using [Bootstrap playbook](./docs/bootstrap.md) ###
`ansibple-playbook -i invventory/polkadot/aws-polkadot_validator_pruned.yml playbooks/bootrap.yml -e default_user=ubuntu`

### Spin up blockchain node with using [substrate_node role](./docs/bootstrap.md) ###
`ansibple-playbook -i invventory/polkadot/aws-polkadot_validator_pruned.yml playbooks/substrate_node.yml --tags install,from-snapshot`
