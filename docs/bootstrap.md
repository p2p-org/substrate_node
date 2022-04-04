# Bootstrap #
| WARNING: This playbook desined ONLY for DEB like operation systems | 
|---|

# You will NOT find here #
## System security hardening ##
We will not provide it. 
Each follow his religion and have own opinion. 

## Extra roles ##
Like node_exporter, ssh, firewall etc.
We respect your choice:)

## Tasks related to performance tunning ##
For the same reasons as above.

# Manage ssh users #
There are included ssh_users tasks (requires ./inventory/projectname/vars/ssh_users.yml)

Scope:
1. Add users
2. Manage their ssh keys
3. Manage sudoers
4. Delete users

Password(should be presented as a sha512) is an optional but strongly recommend.

# Unnatended upgrades #
Enable or disable auto upgrades.
Will skip if ```disable_unattended_upgrades``` variable is defined.

# An additional disk mounting #
Will mount and create entry in fstab if ```extended_disk_name``` variable is defined. This variable distributes by terraform(declare it in config.yml)