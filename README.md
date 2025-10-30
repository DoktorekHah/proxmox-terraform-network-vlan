# Proxmox Network VLAN Terraform Module

A comprehensive Terraform/OpenTofu module for managing Proxmox network VLANs with integrated security scanning (Checkov) and code linting (TFLint). This module supports both Terraform and OpenTofu through a unified Makefile.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-623CE4)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.0-FFDA18)](https://opentofu.org/)

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Examples](#-examples)
- [Makefile Commands](#-makefile-commands)
- [Security & Linting](#-security--linting)
- [Testing](#-testing)
- [Module Reference](#-module-reference)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Core Capabilities
- **Dual Tool Support**: Works with both Terraform and OpenTofu
- **VLAN Management**: Complete VLAN lifecycle management on Proxmox VE
- **Tagged VLANs**: Support for IEEE 802.1Q VLAN tagging
- **Multiple VLANs**: Manage multiple VLANs simultaneously
- **Physical Interface Binding**: Associate VLANs with specific network ports

### Security & Quality
- **Security Scanning**: Integrated Checkov for IaC security analysis
- **Code Linting**: TFLint for Terraform/OpenTofu code quality
- **CI/CD Ready**: Pre-configured pipelines for both Terraform and OpenTofu
- **Best Practices**: Follows Terraform/OpenTofu module best practices

### Advanced Features
- **VLAN Tagging**: IEEE 802.1Q VLAN support for network segmentation
- **Flexible Port Assignment**: Bind VLANs to any physical interface
- **Auto-start**: Configure VLANs to start automatically on boot
- **Custom Comments**: Add descriptive comments to each VLAN
- **Network Isolation**: Create isolated network segments for security

## 🔧 Prerequisites

### Required Tools
- **Terraform** >= 1.6.0 OR **OpenTofu** >= 1.0
- **Python** >= 3.8 (for Checkov security scanning)
- **TFLint** (automatically installed via Makefile)
- **Proxmox VE** cluster with API access

### Optional Tools
- **Go** >= 1.19 (for Terratest integration tests)
- **pipx** or **pip3** (for Checkov installation)

### Provider Requirements
- `bpg/proxmox` >= 0.46.0, < 1.0.0

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install all dependencies (Checkov + TFLint)
make install

# Or install individually
make checkov-install
make tflint-install
```

### 2. Initialize TFLint

```bash
# Initialize TFLint plugins (required once)
make tflint-init
```

### 3. Choose Your Tool

#### Using Terraform:
```bash
# Initialize Terraform
make terraform-init

# Validate configuration
make terraform-validate

# Preview changes
make terraform-plan

# Apply changes
make terraform-apply
```

#### Using OpenTofu:
```bash
# Initialize OpenTofu
make tofu-init

# Validate configuration
make tofu-validate

# Preview changes
make tofu-plan

# Apply changes
make tofu-apply
```

### 4. Run Security & Quality Checks

```bash
# Run all checks
make test-all

# Or run individually
make checkov-scan    # Security scan
make tflint-check    # Code linting
```

## 💻 Usage

### Basic VLAN Configuration

```hcl
module "network_vlan" {
  source = "github.com/your-org/proxmox-terraform-network-vlan"

  node_name = "pve01"

  vlan_settings = {
    vlan10 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Management VLAN"
    }
  }
}
```

### Multiple VLANs Configuration

```hcl
module "network_vlans" {
  source = "github.com/your-org/proxmox-terraform-network-vlan"

  node_name = "pve01"

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
```

### Advanced Configuration with All Features

```hcl
module "network_vlan_advanced" {
  source = "github.com/your-org/proxmox-terraform-network-vlan"

  node_name = "pve01"

  vlan_settings = {
    # Management VLAN (always running)
    management = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Management VLAN - Production Network"
    }
    
    # Guest VLAN for virtual machines
    guest = {
      autostart      = true
      vlan           = 20
      vlan_name_port = "eno1.20"
      comment        = "Guest VLAN - Virtual Machines"
    }
    
    # Storage VLAN (manual start)
    storage = {
      autostart      = false
      vlan           = 30
      vlan_name_port = "eno1.30"
      comment        = "Storage VLAN - iSCSI/NFS"
    }
    
    # IoT VLAN for isolated devices
    iot = {
      autostart      = true
      vlan           = 99
      vlan_name_port = "eno1.99"
      comment        = "IoT VLAN - Isolated Network"
    }
  }
}

# Output specific VLAN details
output "management_vlan" {
  value       = module.network_vlan_advanced.vlan.id["management"]
  description = "Management VLAN ID"
}

output "all_vlans" {
  value       = module.network_vlan_advanced.vlan
  description = "All VLAN configurations"
}
```

### Using Different Physical Interfaces

```hcl
module "network_vlans_multi_nic" {
  source = "github.com/your-org/proxmox-terraform-network-vlan"

  node_name = "pve01"

  vlan_settings = {
    # VLANs on first interface
    vlan10_nic1 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno1.10"
      comment        = "Management on NIC1"
    }
    
    # VLANs on second interface
    vlan10_nic2 = {
      autostart      = true
      vlan           = 10
      vlan_name_port = "eno2.10"
      comment        = "Management on NIC2 (backup)"
    }
    
    # VLANs on bond interface
    vlan20_bond = {
      autostart      = true
      vlan           = 20
      vlan_name_port = "bond0.20"
      comment        = "Guest VLAN on bonded interface"
    }
  }
}
```

## 📂 Examples

The module includes several comprehensive examples:

### Available Examples

- **[basic/](examples/basic/)** - Single VLAN configuration
- **[multiple_vlans/](examples/multiple_vlans/)** - Multiple VLANs with different configurations
- **[comprehensive/](examples/comprehensive/)** - All features combined

### Running Examples

```bash
# Navigate to an example
cd examples/basic

# Set Proxmox credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"
export TF_VAR_node_name="pve01"

# Run Terraform
terraform init
terraform plan
terraform apply

# Clean up
terraform destroy
```

## 📋 Makefile Commands

### Installation & Setup

```bash
make install              # Install all dependencies (Checkov + TFLint)
make checkov-install      # Install Checkov security scanner
make tflint-install       # Install TFLint linter
make tflint-init          # Initialize TFLint plugins
make dev-setup            # Set up complete development environment
```

### Security Scanning (Checkov)

```bash
make checkov-scan         # Run Checkov security scan
make checkov-scan-json    # Run scan with JSON output
make checkov-scan-sarif   # Run scan with SARIF output (CI/CD)
make test-terraform-security  # Run Terraform security tests
make test-tofu-security   # Run OpenTofu security tests
```

### Code Linting (TFLint)

```bash
make tflint-init          # Initialize TFLint plugins
make tflint-check         # Run TFLint code quality checks
make test-tflint          # Run linting tests only
```

### Terraform Commands

```bash
make terraform-init       # Initialize Terraform
make terraform-validate   # Validate Terraform configuration
make terraform-plan       # Create execution plan
make terraform-plan-out   # Create and save execution plan
make terraform-apply      # Apply configuration
make terraform-apply-plan # Apply saved plan
make terraform-destroy    # Destroy infrastructure
make terraform-format     # Format Terraform files
```

### OpenTofu Commands

```bash
make tofu-init            # Initialize OpenTofu
make tofu-validate        # Validate OpenTofu configuration
make tofu-plan            # Create execution plan
make tofu-plan-out        # Create and save execution plan
make tofu-apply           # Apply configuration
make tofu-apply-plan      # Apply saved plan
make tofu-destroy         # Destroy infrastructure
make tofu-format          # Format OpenTofu files
```

### Testing Commands

```bash
make test                 # Run complete test workflow (validate + lint + plan)
make test-all             # Run all tests (security + linting + workflow)
make test-tflint          # Run linting tests only
make test-terraform-security  # Run Terraform security tests
make test-tofu-security   # Run OpenTofu security tests
make test-terratest       # Run Go-based Terratest integration tests
```

### Terratest Commands

```bash
make test-terratest       # Run all terratest tests
make test-basic           # Run basic VLAN test
make test-multiple        # Run multiple VLANs test
make test-plan            # Run plan-only test
make test-validate        # Run validation test
make test-parallel        # Run tests in parallel
make terratest-deps       # Install terratest dependencies
make terratest-fmt        # Format terratest Go code
make terratest-clean      # Clean up terratest artifacts
make terratest-coverage   # Run terratest with coverage report
```

### CI/CD Commands

```bash
make ci                   # Run CI pipeline (security + lint + terraform workflow)
```

### Utility Commands

```bash
make clean                # Clean up generated files
make clean-all            # Clean up all files including state
make help                 # Show all available commands
make docs                 # Display module documentation
```

## 🔒 Security & Linting

### Checkov Security Scanning

This module includes integrated security scanning using [Checkov](https://www.checkov.io/) to ensure your infrastructure code follows security best practices.

**Key Features:**
- 🛡️ Security misconfiguration detection
- ✅ Compliance framework validation
- 📊 Multiple output formats (CLI, JSON, SARIF)
- 🔌 CI/CD integration ready
- 📝 Custom policy support

**Configuration:** `.checkov.yml`

```yaml
framework:
  - terraform

output:
  - cli
  - json
  - sarif

skip-download: true
```

**Usage:**
```bash
# Run security scan
make checkov-scan

# Generate JSON report
make checkov-scan-json

# Generate SARIF report for CI/CD
make checkov-scan-sarif
```

### TFLint Code Quality

TFLint checks your Terraform/OpenTofu code for errors, deprecated syntax, and best practices.

**Key Features:**
- 🔍 Syntax and logic error detection
- 📏 Best practice enforcement
- 🎯 Provider-specific rule sets
- 🔄 Naming convention validation
- 📚 Module version checking

**Configuration:** `.tflint.hcl`

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_naming_convention" {
  enabled = true
}
```

**Usage:**
```bash
# Initialize TFLint (once)
make tflint-init

# Run code quality checks
make tflint-check
```

### Security Best Practices

1. **Always scan before deploy:**
   ```bash
   make checkov-scan && make tflint-check
   ```

2. **Review scan results:**
   - Address all **Failed** checks
   - Understand **Skipped** checks
   - Document exceptions

3. **Integrate into CI/CD:**
   ```bash
   make ci  # Runs security + linting + validation
   ```

## 🧪 Testing

### Quick Test Workflows

```bash
# Run complete test workflow (recommended)
make test-all

# Test Terraform workflow only
make test

# Test security and linting only
make test-terraform-security
make test-tflint
```

### Terratest Integration Tests

This module includes comprehensive automated testing using Terratest:

```bash
# Run all integration tests
make test-terratest

# Run specific test cases
make test-basic           # Basic VLAN test
make test-multiple        # Multiple VLANs test
make test-plan            # Plan-only test
make test-validate        # Validation test

# Run tests in parallel
make test-parallel

# Generate coverage report
make terratest-coverage
```

#### Test Prerequisites

```bash
# Set up Proxmox credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"
export PROXMOX_VE_INSECURE="true"
export TF_VAR_node_name="pve"
```

#### Test Cases

| Test | Description | Example Directory |
|------|-------------|-------------------|
| **Basic** | Single VLAN configuration | `examples/basic` |
| **Multiple** | Multiple VLANs with different configs | `examples/multiple_vlans` |
| **Validation** | Configuration syntax validation | `examples/basic` |
| **Plan** | Terraform plan validation | `examples/basic` |

### CI/CD Pipeline

The `ci` target runs a complete pipeline suitable for CI/CD:

```bash
make ci
```

This executes:
1. Checkov security scan
2. TFLint initialization
3. TFLint code quality check
4. Terraform/OpenTofu initialization
5. Configuration validation
6. Execution plan generation

### Manual Testing

```bash
# 1. Initialize
make terraform-init

# 2. Validate syntax
make terraform-validate

# 3. Check code quality
make tflint-check

# 4. Security scan
make checkov-scan

# 5. Preview changes
make terraform-plan

# 6. Apply (with approval)
make terraform-apply
```

## 📚 Module Reference

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | > 1.8.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement_proxmox) | >= 0.46.0, < 1.0.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider_proxmox) | >= 0.46.0, < 1.0.0 |

#### Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_network_linux_vlan.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_network_linux_vlan) | resource |

#### Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_node_name"></a> [node_name](#input_node_name) | The name of the Proxmox node where the VLAN will be created | `string` | yes |
| <a name="input_vlan_settings"></a> [vlan_settings](#input_vlan_settings) | Map of VLAN configurations with optional settings for autostart, VLAN ID, port name, and comment | <pre>map(object({<br/>    autostart      = optional(bool)<br/>    vlan           = optional(number)<br/>    vlan_name_port = optional(string)<br/>    comment        = optional(string)<br/>  }))</pre> | yes |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_vlan"></a> [vlan](#output_vlan) | vlan id, name |
<!-- END_TF_DOCS -->

## 🛠️ Development

### Setting Up Development Environment

```bash
# Complete setup
make dev-setup

# This will:
# - Install Checkov
# - Install TFLint
# - Initialize TFLint plugins
```

### Code Quality

```bash
# Format code
make terraform-format  # or make tofu-format

# Validate configuration
make terraform-validate  # or make tofu-validate

# Run linting
make tflint-check

# Run security scan
make checkov-scan
```

### Development Workflow

1. **Make Changes**
   ```bash
   # Edit your .tf files
   vim main.tf
   ```

2. **Format Code**
   ```bash
   make terraform-format
   ```

3. **Validate & Lint**
   ```bash
   make terraform-validate
   make tflint-check
   ```

4. **Security Scan**
   ```bash
   make checkov-scan
   ```

5. **Test**
   ```bash
   make terraform-plan
   ```

6. **Clean Up**
   ```bash
   make clean
   ```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
make terraform-plan

# Enable OpenTofu debug logging
export TF_LOG=DEBUG
make tofu-plan

# Clean up everything and start fresh
make clean-all
make terraform-init
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Before Contributing

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow Terraform/OpenTofu best practices
   - Update documentation
   - Add tests if applicable

4. **Run quality checks**
   ```bash
   make terraform-format
   make tflint-check
   make checkov-scan
   make test-all
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "feat: add new feature"
   ```

6. **Submit a pull request**

### Development Guidelines

- ✅ Always run `make checkov-scan` before committing
- ✅ Ensure all tests pass with `make test-all`
- ✅ Follow semantic versioning
- ✅ Update README for new features
- ✅ Add examples for new functionality
- ✅ Document any breaking changes

### Code Style

- Use descriptive variable names
- Add comments for complex logic
- Keep functions small and focused
- Follow the existing code structure

## 📖 Additional Resources

### Documentation
- [Proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Proxmox Network Configuration](https://pve.proxmox.com/wiki/Network_Configuration)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/language/modules/develop)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)

### Networking Resources
- [IEEE 802.1Q VLAN Tagging](https://en.wikipedia.org/wiki/IEEE_802.1Q)
- [VLAN Configuration](https://www.kernel.org/doc/Documentation/networking/vlan.txt)
- [Network Segmentation Best Practices](https://www.cisco.com/c/en/us/solutions/enterprise-networks/what-is-network-segmentation.html)

### Community
- [Proxmox Forum](https://forum.proxmox.com/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core)
- [OpenTofu Community](https://opentofu.org/community/)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/your-org/repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/repo/discussions)
- **Security**: Report security issues privately to security@your-org.com

## 🙏 Acknowledgments

- [BPG Proxmox Provider](https://github.com/bpg/terraform-provider-proxmox) - Excellent Proxmox provider
- [Checkov](https://www.checkov.io/) - Infrastructure security scanning
- [TFLint](https://github.com/terraform-linters/tflint) - Terraform linting

---

**⚠️ Important Notes:**

- Always review security scan results before deploying to production
- Test changes in a development environment first
- Verify physical network interfaces exist before creating VLANs
- Ensure VLAN IDs don't conflict with existing network configuration
- Keep your Proxmox API credentials secure
- Regularly update providers and tools to latest versions
- Back up your Terraform/OpenTofu state files
- VLANs require trunk ports on connected switches

**VLAN Best Practices:**

- Use VLAN IDs between 2-4094 (avoid VLAN 1 for security reasons)
- Document your VLAN scheme (management, guest, storage, etc.)
- Implement proper network segmentation for security
- Test VLAN connectivity before production deployment
- Monitor VLAN traffic and adjust as needed
- Use consistent naming conventions (e.g., eno1.10 for VLAN 10 on eno1)
- Ensure parent interfaces support VLAN tagging
- Configure corresponding switch ports as trunk/tagged

**Made with ❤️ for the Proxmox and Terraform/OpenTofu community**
