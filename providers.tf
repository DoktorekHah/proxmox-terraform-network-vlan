terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.46.0, < 1.0.0"
    }
  }
  required_version = "> 1.8.0"
}