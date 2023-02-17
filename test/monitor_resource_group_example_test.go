package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMonitorResourceGroupExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/monitor-resource-group",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
