
variable "virtual_network_rg" {
  description = "(Required) Name of the resource group where to create the vnet"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
  type        = string
}

variable "prefix" {
  description = "(Optional) You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "diagnostics_map" {
  description = "(Required) contains the SA and EH details for operations diagnostics"
}

variable "log_analytics_workspace" {
  description = "(Required) contains the log analytics workspace details for operations diagnostics"
}

variable "diagnostics_settings" {
  description = "(Required) configuration object describing the diagnostics"
}

variable "networking_object" {
  description = "(Required) configuration object describing the networking configuration, as described in README"
}

variable "convention" {
  description = "(Required) Naming convention method to use"  
}