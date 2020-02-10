locals {
  # If var.path is defined, it takes precedence over the constructed path
  path = coalesce(
    var.path,
    join("/", [var.scope, var.owner, module.secret_label.id]),
  )
  full_path = join("/", [var.mount_path, local.path])
}

module "secret_label" {
  source              = "git@github.com:3scale/tf-aws-label.git?ref=tags/0.1.1"
  project             = var.project
  environment         = var.environment
  workload            = var.workload
  type                = var.type
  enabled             = var.enabled
  delimiter           = var.delimiter
  attributes          = var.attributes
  context             = var.context
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars
}

resource "vault_generic_secret" "write" {
  count = var.write ? 1 : 0
  path  = local.full_path
  data_json  = var.value
}

data "vault_generic_secret" "read" {
  count = "${var.write ? 0 : 1}"
  path  = local.full_path
}