variable "node_name" {
  description = "The name of the Proxmox node where the VLAN will be created"
  type        = string
}

variable "vlan_settings" {
  description = "Map of VLAN configurations with optional settings for autostart, VLAN ID, port name, and comment"
  type = map(object({
    autostart      = optional(bool)
    vlan           = optional(number)
    vlan_name_port = optional(string)
    comment        = optional(string)
  }))
}
