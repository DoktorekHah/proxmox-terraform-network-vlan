module "vlan" {
  source = "../.."

  node_name = "pve"

  vlan_settings = {
    vlan10 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Management VLAN - Production Network"
    }
    vlan20 = {
      autostart      = true
      vlan           = 20
      vlan_name_port = "eno1.20"
      comment        = "Guest VLAN - Virtual Machines"
    }
    vlan30 = {
      autostart      = false
      vlan           = 30
      vlan_name_port = "eno1.30"
      comment        = "Storage VLAN - iSCSI/NFS"
    }
    vlan99 = {
      autostart      = true
      vlan           = 99
      vlan_name_port = "eno1.99"
      comment        = "IoT VLAN - Isolated Network"
    }
  }
}

output "vlan" {
  value       = module.vlan.vlan
  description = "All VLAN configurations"
}

