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

module "storage" {
  source = "github.com/equinor/terraform-azurerm-storage?ref=v10.3.0"

  account_name                 = "st${random_id.example.hex}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  shared_access_key_enabled    = true
  network_rules_default_action = "Allow"
}

resource "azurerm_storage_queue" "example" {
  name                 = "event-queue"
  storage_account_name = module.storage.account_name
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

  event_subscriptions = {
    "example" = {
      name = "evgs-${random_id.example.hex}"

      storage_queue_endpoint = {
        storage_account_id = module.storage.account_id
        queue_name         = azurerm_storage_queue.example.name
      }
    }
  }
}
