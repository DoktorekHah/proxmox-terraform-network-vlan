variable "proxmox_endpoint" {
  description = "The Proxmox API endpoint"
  type        = string
  default     = "https://proxmox.local:8006"
}

variable "proxmox_username" {
  description = "The Proxmox username"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "The Proxmox password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

