resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}
resource "azurerm_cdn_frontdoor_origin_group" "appgw_backend_pool" {
  for_each                 = var.backend_pool_settings
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = true
  dynamic "health_probe" {
    for_each = each.value.health_probe_enabled ? [1] : []
    content {
      path                = each.value.health_probe_path
      protocol            = each.value.health_probe_protocol
      interval_in_seconds = each.value.health_probe_interval_in_seconds
    }
  }
  dynamic "load_balancing" {
    for_each = each.value.load_balancing_enabled ? [1] : []
    content {
      sample_size                 = 4
      successful_samples_required = 2
    }
  }
}
resource "azurerm_cdn_frontdoor_origin" "appgw_origin" {
  for_each                       = var.backends
  name                           = each.key
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.appgw_backend_pool[each.key].id
  host_name                      = each.value.host_header
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = each.value.host_header
  certificate_name_check_enabled = true
}
resource "azurerm_cdn_frontdoor_endpoint" "default" {
  name                     = "default"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}
resource "azurerm_cdn_frontdoor_custom_domain" "frontend" {
  for_each                 = var.frontend_endpoints
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  host_name                = each.value.host_name
  dynamic "tls" {
    for_each = each.value.certificate_key_vault_secret_id != "" ? [1] : []
    content {
      certificate_type = "Customer"
      #certificate_key_vault_secret_id = each.value.certificate_key_vault_secret_id
    }
  }
}
resource "azurerm_cdn_frontdoor_route" "routing_rules" {
  for_each = var.routing_rules
  name     = each.key
  #cdn_frontdoor_profile_id   = azurerm_cdn_frontdoor_profile.main.id
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_custom_domain.frontend[each.value.frontend_endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.appgw_backend_pool[each.value.backend_pool_name].id
  cdn_frontdoor_origin_ids = [
    for origin in azurerm_cdn_frontdoor_origin.appgw_origin : origin.id
    if origin.cdn_frontdoor_origin_group_id == azurerm_cdn_frontdoor_origin_group.appgw_backend_pool[each.value.backend_pool_name].id
  ]
  supported_protocols = ["Http", "Https"]
  patterns_to_match   = each.value.route_paths
}