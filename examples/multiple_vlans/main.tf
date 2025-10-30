module "vlan" {
  source = "../.."

  node_name = "pve"

  vlan_settings = {
    vlan10 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Management VLAN"
    }
    vlan20 = {
      autostart      = true
      vlan           = 20
      vlan_name_port = "eno1.20"
      comment        = "Guest VLAN"
    }
    vlan30 = {
      autostart      = true
      vlan           = 30
      vlan_name_port = "eno1.30"
      comment        = "Storage VLAN"
    }
  }
}

output "vlan" {
  value = module.vlan.vlan
}

