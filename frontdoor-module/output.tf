output "frontdoor_id" {
  description = "The ID of the Azure Front Door Profile."
  value       = azurerm_cdn_frontdoor_profile.main.id
}
output "frontdoor_host_name" {
  description = "The default host name of the Front Door Profile."
  value       = azurerm_cdn_frontdoor_endpoint.default.host_name
}