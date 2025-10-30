output "vlan" {
  value = {
    id   = { for k, v in proxmox_virtual_environment_network_linux_vlan.this : k => v.id }
    name = { for k, v in proxmox_virtual_environment_network_linux_vlan.this : k => v.name }
    vlan = { for k, v in proxmox_virtual_environment_network_linux_vlan.this : k => v.vlan }

  }
  description = "vlan id, name"
}