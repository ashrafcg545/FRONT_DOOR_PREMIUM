name                = "my-frontdoor-waf-policy"
resource_group_name = "my-resource-group"
location            = "East US"

custom_rules = {
  "block-sql" = {
    name           = "BlockSQLInjection"
    priority       = 1
    rule_type      = "MatchRule"
    action         = "Block"
    match_variable = "RequestHeader"
    operator       = "Contains"
    match_values   = ["SELECT", "INSERT", "DELETE"]
    transforms     = ["Lowercase"]
  }
}

tags = {
  environment = "production"
}