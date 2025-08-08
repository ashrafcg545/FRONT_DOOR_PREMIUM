provider "azurerm" {
  features {}
}
module "frontdoor" {
  source                = "../frontdoor-module"
  resource_group_name   = var.resource_group_name
  location              = var.location
  frontdoor_name        = var.frontdoor_name
  backends              = var.backends
  backend_pool_settings = var.backend_pool_settings
  frontend_endpoints    = var.frontend_endpoints
  routing_rules         = var.routing_rules
}
output "frontdoor_host_name" {
  description = "The default hostname of the Azure Front Door profile."
  value       = module.frontdoor.frontdoor_host_name
}