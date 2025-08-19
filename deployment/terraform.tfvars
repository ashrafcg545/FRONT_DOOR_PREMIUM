resource_group_name = "rg-nl-tmac-acc-fd-euw-k42ok-001"
location            = "west europe"
frontdoor_name      = "fd-tmac-dev-euw-qz1h0-001"
backends = {
  "app-gateway-1-backend" = {
    application_gateway_id = "/subscriptions/262f49ca-b135-418b-99d9-b72784756c57/resourceGroups/rg-nl-tmac-acc-fd-euw-k42ok-001/providers/Microsoft.Network/applicationGateways//subscriptions/262f49ca-b135-418b-99d9-b72784756c57/resourceGroups/rg-cf-tmac-acc-euw-k42ok-001/providers/Microsoft.Network/applicationGateways/appgw-cf-tmac-acc-euw-k42ok-002"
    host_header            = "developer.acc.tennet.eu"
    backend_pool_name      = "appgw-backend-pool-1"
  },
  "app-gateway-2-backend" = {
    application_gateway_id = "/subscriptions/262f49ca-b135-418b-99d9-b72784756c57/resourceGroups/rg-nl-tmac-acc-fd-euw-k42ok-001/providers/Microsoft.Network/applicationGateways//subscriptions/262f49ca-b135-418b-99d9-b72784756c57/resourceGroups/rg-cf-tmac-acc-euw-k42ok-001/providers/Microsoft.Network/applicationGateways/appgw-cf-tmac-acc-euw-k42ok-002"
    host_header            = "identity.acc.tennet.eu"
    backend_pool_name      = "appgw-backend-pool-2"
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
    host_name                          = "developer.acc.tennet.eu"
    web_application_firewall_policy_id = ""
    certificate_key_vault_secret_id    = "/subscriptions/7445369d-e7e5-4ba8-b4e0-a3da378def4c/resourceGroups/rg-tmac-acc-euw-17dei-003/providers/Microsoft.KeyVault/vaults/kvtmacacceuw17dei001/secrets/developer-acc-tennet-eu"
  },
  "app2-endpoint" = {
    host_name                          = "identity.acc.tennet.eu"
    web_application_firewall_policy_id = ""
    certificate_key_vault_secret_id    = "/subscriptions/7445369d-e7e5-4ba8-b4e0-a3da378def4c/resourceGroups/rg-tmac-acc-euw-17dei-003/providers/Microsoft.KeyVault/vaults/kvtmacacceuw17dei001/secrets/developer-acc-tennet-eu"
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