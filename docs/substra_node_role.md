# Substrate node ansible role #
Ansible role for working around substrate based blockchain nodes.

## urls ##
Substrate home page https://substrate.dev/ \
Substrate github https://github.com/paritytech/substrate/ \
Polkadot home page https://wiki.polkadot.network/ \
Polkadot github https://github.com/paritytech/polkadot/ 

## variables ##
| Name                   | Related to                           | Location         | Example                                                                    | Descr                                          |
|------------------------|--------------------------------------|------------------|----------------------------------------------------------------------------|------------------------------------------------|
| node_binary_name       | install [common]                     | group_vars/all   | polkadot                                                                   | binary name                                    |
| node_binary_dir        | install [common]                     | role/default     | /usr/local/bin                                                             | binary dir                                     |
| node_home_dir          | install [common]                     | group_vars/all   | /home/polkadot/                                                            | home dir                                       |
| node_log_dir           | install [common]                     | group_vars/all   | /var/log/polkadot                                                          | log dir                                        |
| node_binary_url        | install [common]                     | group_vars/all   | https://github.com/paritytech/polkadot/releases/download/v0.9.9-1/polkadot | binary url                                     |
| node_user              | install [common]                     | group_vars/all   | polkadot                                                                   | user                                           | 
| node_group             | install [common]                     | group_vars/all   | polkadot                                                                   | group                                          |
| db_snapshot_url        | install [relaychain]                 | group_vars/group | https://dot-rocksdb.polkashots.io/snapshot                                 | https://polkashots.io                          |
| node_safe_restart      | safe_restart                         | group_vars/group | yes                                                                        | Safe rewtart when defined                      |
| public_node_rpc_url    | safe_restart                         | group_vars/all   | http://35.246.223.146:9933/                                                | RPC url of a public node                       |
| node_slack_channel     | session_keys, validate, chill        | group_vars/all   | https://hooks.slack.com/services/TCR380WSE/B015YHQJR2P/dsfdsgsdt           | slack channel                                  |
| node_rpc_port          | session_keys, dynamic_reserved_nodes | role/default     | 9933                                                                       | RPC port                                       |
| public_node_ws_url     | session_keys, validate, chill        | group_vars/all   | ws://35.246.223.146:9944/                                                  | WS port of a public node                       |
| path                   | session_keys, validate, chill        | extra_vars       | /mnt/mountpoint                                                            | PATH where controller's mnemonic located(json) |
| relay_chain            | install/upgrade/config [relaychain]  | group_vars/all   | polkadot                                                                   | Value for parameter --chain                    |
| relaychain_db_path     | install [relaychain]                 | group_vars/all   | .local/share/acala/polkadot/chains/ksmcc3                                  | DB path                                        |
| relay_db_snapshot_url  | install [relaychain]                 | group_vars/all   | https://storage.googleapis.com/polkadot_snapshots/kusama.tar               | Where DB snapshot is located                   |
| para_chain             | install/upgrade/config [parachain]   | group_vars/all   | polkadot                                                                   | Value for parameter --chain                    |
| parachain_db_path     | install [parachain]                   | group_vars/all   | .local/share/acala/chains/karura                                           | DB path                                        |
| parachain_db_snapshot_url  | install [parachain]              | group_vars/all   | https://storage.googleapis.com/polkadot_snapshots/karura.tar               | Where DB snapshot is located                   |                                        
| node_relaychain_args   | install/upgrade/config [relaychain]  | group_vars/group | yml list(all possible args)                                                | Arguments related relaychain side              |
| node_parachain_args    | install/upgrade/config [parachain]   | group_vars/group | yml list(all possible args)                                                | Arguments related parachain side               |
| dynamic_reserved_nodes | safe_restart, any [relaychain]       | group_vars/group | yml list(with reserved nodes ip adderesses) you must have RPC access there | Reserved nodes defined dynamically(RPC)        |

## Playbooks ##
### substrate_node.yml ###
The general playbook.

| Tags                  | Extra tags                                                         | Extra vars | Extra roles | Descr                                  |
|-----------------------|--------------------------------------------------------------------|------------|-------------|----------------------------------------|
| None                  | None                                                               | None       | None        | Generate config file                                                           |
| install               | from-snapshot, skip-config, skip-delete-keys                       | None       | None        | Install blockchain node                                                        |
| upgrade               | skip-config                                                        | None       | None        | Upgrade blockchain node                                                        |
| revert                | skip-config                                                        | None       | None        | Revert to previos binary                                                       |
| stop                  | None                                                               | None       | None        | Stop Node                                                                      |
| restart               | None                                                               | None       | None        | Restart node                                                                   | 
| destroy-db            | None                                                               | None       | None        | Stop node and destroy db and keys                                              |
| list-keys             | None                                                               | None       | None        | Simple listing of keys in keystore                                             |
| rotate-keys           | sign                                                               | path       | None        | Rotate session keys                                                            |
| backup-keys           | None                                                               | path       | None        | Backup session keys                                                            |
| restore-keys          | None                                                               | path, name | None        | Restore session keys                                                           |                                             

## Examples ##
#### Simple install ####
`playbooks/substrate_node.yml --tags install`

#### Install with using db snapshot ####
###### Note: variable ```relay_db_snapshot_url``` must be specified. In case you want also use para snapshot then ```parachain _db_snapshot_url``` also must be specified ###### 
`playbooks/substrate_node.yml --tags install,from-snapshot`

#### Simple upgrade ####
`playbooks/substrate_node.yml --tags upgrade`

#### Upgrade with skipping config generation ####
`playbooks/substrate_node.yml --tags upgrade,skip-config`

#### Revert to previous version ####
`playbooks/substrate_node.yml --tags revert`

#### Stop node ####
`playbooks/substrate_node.yml --tags stop`

#### Restart node ####
######  Note: will use safe_restart mechanizm in case if variable ```node_safe_restart``` is defined and not null. ###### 
`playbooks/substrate_node.yml --tags restart`

#### Destroy db ####
###### Note: will delete only DB folder(keystore and network will be leave) ###### 
`playbooks/substrate_node.yml --tags destroy-db`

#### Rotate session keys ####
`playbooks/substrate_node.yml --tags rotate-keys`

#### List of node keystore ####
###### Note: will list of keystore directory ######
`playbooks/substrate_node.yml --tags list-keys`

#### Validate DB(compare block hash from node and same from public one) ####
`playbooks/substrate_node.yml --tags verify-db`

#### Define dynamic reserved nodes(via RPC call) ####
###### Note: List like presented bellow must be specified somewhere ######
---
    dynamic_reserved_nodes:
    - 1.1.1.1
    - 2.2.2.2
    - 3.3.3.3
