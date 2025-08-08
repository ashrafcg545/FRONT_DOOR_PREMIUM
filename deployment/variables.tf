variable "resource_group_name" {
  description = "The name of the resource group where the Front Door will be deployed."
  type        = string
}
variable "location" {
  description = "The Azure region where the Front Door will be deployed."
  type        = string
}
variable "frontdoor_name" {
  description = "The name of the Azure Front Door Profile. Must be globally unique."
  type        = string
}
variable "backends" {
  description = "A map of Application Gateway backends. The key is the backend name."
  type = map(object({
    application_gateway_id = string
    host_header            = string
  }))
}
variable "backend_pool_settings" {
  description = "A map of backend pool settings. The key is the name of the backend pool."
  type = map(object({
    health_probe_enabled             = bool
    health_probe_path                = string
    health_probe_protocol            = string
    health_probe_interval_in_seconds = number
    load_balancing_enabled           = bool
  }))
  default = {}
}
variable "frontend_endpoints" {
  description = "A map of frontend endpoints. The key is the endpoint name."
  type = map(object({
    host_name                          = string
    web_application_firewall_policy_id = string
    certificate_key_vault_secret_id    = string
  }))
  default = {}
}
variable "routing_rules" {
  description = "A map of routing rules to connect frontends to backend pools."
  type = map(object({
    frontend_endpoint_name = string
    backend_pool_name      = string
    route_paths            = list(string)
    redirect_enabled       = bool
    redirect_type          = string
    redirect_protocol      = string
  }))
}