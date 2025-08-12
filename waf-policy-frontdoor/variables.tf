variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "custom_rules" {
  type = map(object({
    name           = string
    priority       = number
    rule_type      = string
    action         = string
    match_variable = string
    operator       = string
    match_values   = list(string)
    transforms     = list(string)
  }))
}
variable "tags" {
  type    = map(string)
  default = {}
}