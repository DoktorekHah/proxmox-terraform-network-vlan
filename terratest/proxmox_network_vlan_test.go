package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestProxmoxNetworkVLANBasic tests basic network VLAN creation
func TestProxmoxNetworkVLANBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	vlanOutput := terraform.OutputMap(t, terraformOptions, "vlan")

	// Assert that the output map is not empty
	assert.NotEmpty(t, vlanOutput, "VLAN output should not be empty")

	// Check that expected keys exist in the output
	assert.Contains(t, vlanOutput, "id", "VLAN should contain 'id' key")
	assert.Contains(t, vlanOutput, "name", "VLAN should contain 'name' key")
	assert.Contains(t, vlanOutput, "vlan", "VLAN should contain 'vlan' key")
}

// TestProxmoxNetworkVLANMultiple tests multiple network VLAN creation
func TestProxmoxNetworkVLANMultiple(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/multiple_vlans",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	output := terraform.OutputJson(t, terraformOptions, "vlan")

	// Assert that the output is not empty
	assert.NotEmpty(t, output, "VLAN output should not be empty")
}

// TestProxmoxNetworkVLANPlanOnly tests that terraform plan runs without errors
func TestProxmoxNetworkVLANPlanOnly(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
		PlanFilePath: "./plan",
	}

	// Run "terraform init" and "terraform plan"
	terraform.Init(t, terraformOptions)

	// This will save the plan to the PlanFilePath
	exitCode := terraform.Plan(t, terraformOptions)

	// Assert that the plan was successful (exit code 0 or 2)
	// Exit code 2 means there are changes to apply (expected)
	assert.Contains(t, []int{0, 2}, exitCode, "Terraform plan should complete successfully")
}

// TestProxmoxNetworkVLANValidation tests input validation
func TestProxmoxNetworkVLANValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	}

	// Run "terraform init" to install providers
	terraform.Init(t, terraformOptions)

	// Run "terraform validate" to check configuration syntax
	terraform.Validate(t, terraformOptions)
}
