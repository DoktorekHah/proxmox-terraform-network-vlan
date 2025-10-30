# Comprehensive VLAN Example

This example demonstrates a comprehensive VLAN configuration with multiple VLANs for different purposes.

## VLANs Configured

- **VLAN 10**: Management VLAN (autostart enabled)
- **VLAN 20**: Guest VLAN for virtual machines (autostart enabled)
- **VLAN 30**: Storage VLAN for iSCSI/NFS (autostart disabled)
- **VLAN 99**: IoT VLAN for isolated devices (autostart enabled)

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# Destroy the resources
terraform destroy
```

## Variables

Set the following variables either in a `terraform.tfvars` file or via environment variables:

```hcl
proxmox_endpoint = "https://proxmox.local:8006"
proxmox_username = "root@pam"
proxmox_password = "your-password"
proxmox_insecure = true
```

