resource "azurerm_eventgrid_system_topic" "this" {
  name                   = var.system_topic_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = var.source_arm_resource_id
  topic_type             = var.topic_type

  tags = var.tags
}

resource "azurerm_eventgrid_system_topic_event_subscription" "this" {
  for_each = var.event_subscriptions

  name                  = each.value["name"]
  system_topic          = azurerm_eventgrid_system_topic.this.name
  resource_group_name   = azurerm_eventgrid_system_topic.this.resource_group_name
  included_event_types  = each.value["included_event_types"]
  event_delivery_schema = "EventGridSchema"

  dynamic "azure_function_endpoint" {
    for_each = each.value["azure_function_endpoint"] != null ? [each.value["azure_function_endpoint"]] : []

    content {
      function_id                       = azure_function_endpoint.value["function_id"]
      max_events_per_batch              = 1
      preferred_batch_size_in_kilobytes = 64
    }
  }

  dynamic "storage_queue_endpoint" {
    for_each = each.value["storage_queue_endpoint"] != null ? [each.value["storage_queue_endpoint"]] : []

    content {
      storage_account_id = storage_queue_endpoint.value["storage_account_id"]
      queue_name         = storage_queue_endpoint.value["queue_name"]
    }
  }

  dynamic "webhook_endpoint" {
    for_each = each.value["webhook_endpoint"] != null ? [each.value["webhook_endpoint"]] : []

    content {
      url = webhook_endpoint.value["url"]
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "failure-logs"
  target_resource_id         = azurerm_eventgrid_system_topic.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "DeliveryFailures"
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
