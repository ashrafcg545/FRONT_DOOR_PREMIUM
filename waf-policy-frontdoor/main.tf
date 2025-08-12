provider "azurerm" {
  features {}
}

module "frontdoor_waf" {
  source              = "../waf-policy-module"
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  custom_rules        = var.custom_rules
  tags                = var.tags
}