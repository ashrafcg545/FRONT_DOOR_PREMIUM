resource_group_name = "my-resource-group"
location            = "East US"
frontdoor_name      = "my-globally-unique-frontdoor-name"
backends = {
  "app-gateway-1-backend" = {
    application_gateway_id = "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationGateways/app-gateway-1"
    host_header            = "app-gw-1.yourcompany.com"
  },
  "app-gateway-2-backend" = {
    application_gateway_id = "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationGateways/app-gateway-2"
    host_header            = "app-gw-2.yourcompany.com"
  }
}
backend_pool_settings = {
  "appgw-backend-pool-1" = {
    health_probe_enabled             = true
    health_probe_path                = "/health"
    health_probe_protocol            = "Https"
    health_probe_interval_in_seconds = 30
    load_balancing_enabled           = true
  },
  "appgw-backend-pool-2" = {
    health_probe_enabled             = true
    health_probe_path                = "/api/health"
    health_probe_protocol            = "Https"
    health_probe_interval_in_seconds = 30
    load_balancing_enabled           = true
  }
}
frontend_endpoints = {
  "app1-endpoint" = {
    host_name                          = "app1.yourcompany.com"
    web_application_firewall_policy_id = ""
    certificate_key_vault_secret_id    = "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-key-vault/secrets/my-ssl-cert-1/my-cert-version"
  },
  "app2-endpoint" = {
    host_name                          = "app2.yourcompany.com"
    web_application_firewall_policy_id = ""
    certificate_key_vault_secret_id    = "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-key-vault/secrets/my-ssl-cert-2/my-cert-version"
  }
}
routing_rules = {
  "app1-routing" = {
    frontend_endpoint_name = "app1-endpoint"
    backend_pool_name      = "appgw-backend-pool-1"
    route_paths            = ["/*"]
    redirect_enabled       = false
    redirect_type          = ""
    redirect_protocol      = ""
  },
  "app2-routing" = {
    frontend_endpoint_name = "app2-endpoint"
    backend_pool_name      = "appgw-backend-pool-2"
    route_paths            = ["/api/*"]
    redirect_enabled       = false
    redirect_type          = ""
    redirect_protocol      = ""
  }
}