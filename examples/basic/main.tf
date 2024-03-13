provider "azurerm" {
  features {}
}

resource "random_id" "example" {
  byte_length = 8
}

module "log_analytics" {
  source = "github.com/equinor/terraform-azurerm-log-analytics?ref=v2.1.1"

  workspace_name      = "log-${random_id.example.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}

module "event_grid" {
  # source = "github.com/equinor/terraform-azurerm-event-grid"
  source = "../.."

  system_topic_name          = "egst-${random_id.example.hex}"
  resource_group_name        = var.resource_group_name
  location                   = "Global"
  topic_type                 = "Microsoft.Resources.ResourceGroups"
  source_arm_resource_id     = data.azurerm_resource_group.example.id
  log_analytics_workspace_id = module.log_analytics.workspace_id
}
