AZ_FD_WAF_POLICY = {
  policy-one = {
    resource_group_name = "rg-frontdoor"
    sku_name            = "Premium_AzureFrontDoor"
    enabled             = true
    mode                = "Prevention"
    redirect_url        = null
    custom_block_response_status_code = 403
    custom_block_response_body        = null
    js_challenge_cookie_expiration_in_minutes = 30

    custom_rules = [
      {
        name        = "BlockBadBots"
        enabled     = true
        priority    = 1
        rate_limit_duration_in_minutes = 1
        rate_limit_threshold           = 100
        type        = "MatchRule"
        action      = "Block"
        match_conditions = [
          {
            match_variable     = "RequestHeader"
            operator           = "Contains"
            match_values       = ["BadBot"]
            selector           = "User-Agent"
            negation_condition = false
            transforms         = []
          }
        ]
      }
    ]

    managed_rules = [
      {
        type    = "DefaultRuleSet"
        version = "1.0"
        action  = "Block"
      }
    ]

    log_scrubbing_enabled = false
    scrubbing_rules = []

    tags = {
      environment = "prod"
    }
  }

  policy-two = {
    resource_group_name = "rg-frontdoor"
    sku_name            = "Standard_AzureFrontDoor"
    enabled             = true
    mode                = "Detection"
    redirect_url        = null
    custom_block_response_status_code = 403
    custom_block_response_body        = null
    js_challenge_cookie_expiration_in_minutes = 30

    custom_rules = []

    managed_rules = [
      {
        type    = "BotProtectionRuleSet"
        version = "1.0"
        action  = "Log"
      }
    ]

    log_scrubbing_enabled = true
    scrubbing_rules = [
      {
        match_variable = "RequestBody"
        operator       = "Equals"
        selector       = "password"
        enabled        = true
      }
    ]

    tags = {
      environment = "dev"
    }
  }
}
