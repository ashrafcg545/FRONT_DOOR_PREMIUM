###############################################################################
#  VARIABLE DECLARATIONS MOVED TO VARIABLES.TF #
###############################################################################

###############################################################################
#  PROVIDER SETUP  #
###############################################################################

provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

###############################################################################
#  FRONTDOOR WAF POLICY SETUP  #
###############################################################################

resource "azurerm_cdn_frontdoor_firewall_policy" "RES_FD_WAF_POLICY" {
  for_each = var.AZ_FD_WAF_POLICY

  name                              = each.key
  resource_group_name               = each.value.resource_group_name
  sku_name                          = each.value.sku_name
  enabled                           = each.value.enabled
  mode                              = each.value.mode
  redirect_url                      = each.value.redirect_url
  custom_block_response_status_code = each.value.custom_block_response_status_code
  custom_block_response_body        = each.value.custom_block_response_body
  #js_challenge_cookie_expiration_in_minutes = each.value.js_challenge_cookie_expiration_in_minutes

  # dynamic "log_scrubbing" {
  #   for_each = each.value.log_scrubbing_enabled ? [1] : []
  #   content {
  #     enabled = true
  #     dynamic "scrubbing_rule" {
  #       for_each = each.value.scrubbing_rules
  #       content {
  #         match_variable = scrubbing_rule.value.match_variable
  #         operator       = scrubbing_rule.value.operator
  #         selector       = scrubbing_rule.value.selector
  #         enabled        = scrubbing_rule.value.enabled
  #       }
  #     }
  #   }
  # }
  dynamic "custom_rule" {
    for_each = each.value.custom_rules
    content {
      name                           = custom_rule.value.name
      enabled                        = custom_rule.value.enabled
      priority                       = custom_rule.value.priority
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold
      type                           = custom_rule.value.type
      action                         = custom_rule.value.action

      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          match_variable     = match_condition.value.match_variable
          operator           = match_condition.value.operator
          match_values       = match_condition.value.match_values
          selector           = match_condition.value.selector
          negation_condition = match_condition.value.negation_condition
          transforms         = match_condition.value.transforms
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = each.value.managed_rules
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = managed_rule.value.action
    }
  }



  tags = each.value.tags

  lifecycle {
    ignore_changes = [
      tags["createdBy"],
      tags["createdDateTime"]
    ]
  }
}
