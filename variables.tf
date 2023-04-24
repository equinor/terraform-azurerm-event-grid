variable "system_topic_name" {
  description = "The name of this Event Grid system topic."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "topic_type" {
  description = "The topic type of the Event Grid system topic."
  type        = string
}

variable "source_arm_resource_id" {
  description = "The ID of the source ARM resource to create this Event Grid system topic for."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}
variable "log_analytics_destination_type" {
  description = "the type of log analytics destination to use for this Log Analytics Workspace."
  type        = string
  default     = null
}

variable "diagnostic_setting_name" {
  description = "the name of this diagnostic setting."
  type        = string
  default     = null
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)

  default = ["DeliveryFailures"]
}

variable "event_subscriptions" {
  description = "A map of event subscription to create for this Event Grid system topic. One of the endpoints must be specified."

  type = map(object({
    name                 = string
    included_event_types = optional(list(string))

    azure_function_endpoint = optional(object({
      function_id = string
    }))

    storage_queue_endpoint = optional(object({
      storage_account_id = string
      queue_name         = string
    }))

    webhook_endpoint = optional(object({
      url = string
    }))
  }))

  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
