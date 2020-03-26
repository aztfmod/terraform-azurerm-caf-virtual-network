
variable "virtual_network_rg" {
  description = "(Required) Name of the resource group where to create the vnet"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
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

variable "netwatcher" {
  description = "(Optional) is a map with two attributes: name, rg who describes the name and rg where the netwatcher was already deployed" 
  default = {}
}

variable "ddos_id" {
  description = "(Optional) ID of the DDoS protection plan if exists" 
  default = ""
}

variable "prefix" {
  description = "(Optional) You can use a prefix to the name of the resource"
  type        = string
  default = ""
}

variable "postfix" {
  description = "(Optional) You can use a postfix to the name of the resource"
  type        = string
  default = ""
}

variable "max_length" {
  description = "(Optional) You can speficy a maximum length to the name of the resource"
  type        = string
  default = "60"
}
