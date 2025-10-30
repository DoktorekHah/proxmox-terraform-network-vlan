module "vlan" {
  source = "../.."

  node_name = "pve"

  vlan_settings = {
    vlan10 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Basic VLAN 10"
    }
  }
}

output "vlan" {
  value = module.vlan.vlan
}

