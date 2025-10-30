resource "proxmox_virtual_environment_network_linux_vlan" "this" {
  for_each = var.vlan_settings
  provider = proxmox

  node_name = var.node_name
  autostart = each.value.autostart
  name      = each.value.vlan_name_port
  vlan      = each.value.vlan
  comment   = each.value.comment
}