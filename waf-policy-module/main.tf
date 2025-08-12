resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action

      match_conditions {
        match_variable   = custom_rules.value.match_variable
        operator         = custom_rules.value.operator
        match_values     = custom_rules.value.match_values
        transforms       = custom_rules.value.transforms
        negate_condition = false
      }
    }
  }

  managed_rule_set {
    type    = var.managed_rule_set_type
    version = var.managed_rule_set_version
  }

  tags = var.tags
}