# tf-vault-secret

This module tries to standarize the way we store secrets in the KeyValueV2 Vault's storage engine. It leverages the existent naming convention and implemented in https://github.com/3scale/tf-aws-label to create secrets in a consistent way.

## How does it work

`tf-vault-secret` can be used both to read and write secrets. This is controlled by the `write` boolean variable: if set to `true` its a write operation, if set to `false` (default) is a read operation.

The path were the secret is written to or read from is automatically calculated by the set of labels passed to the module. It supports almost the same input variables as the `tf-aws-label` module, so it essentially can be called in one of the following ways:

### Write

* Specify all the input variables.

```
module "vault_secret" {
  source      = "git@github.com:3scale/tf-vault-secret.git?ref=tags/0.1.0"
  write       = true
  scope       = "teams"
  owner       = "operations"
  environment = local.environment
  project     = local.project
  workload    = local.workload
  type        = "some-type"
  value       = jsonencode({
    "key1" = some_resource.some_sensible_attr,
    "key2" = some_resource.some_other_sensible_attr,
  })
}
```

* Passing the full set of labels (context) of an already defined label. This is the preferred way as it keeps the names/labes of the resource with the path were its related secret is storer.

```
module "user_label" {
  source      = "git@github.com:3scale/tf-aws-label.git?ref=tags/0.1.1"
  environment = local.environment
  project     = local.project
  workload    = local.workload
  type        = "some-type"
  tf_config   = local.tf_config
}

module "vault_secret" {
  source  = "git@github.com:3scale/tf-vault-secret.git?ref=tags/0.1.0"
  context = module.user_label.context
  write   = true
  scope   = "teams"
  owner   = "operations"
  value   = jsonencode({
    "key1" = some_resource.some_sensible_attr,
    "key2" = some_resource.some_other_sensible_attr,
  })
}
```

* Override the constructed path: it is possible to specify the full `path` of the secret if needed.

```
module "vault_secret" {
  source  = "/home/roi/github.com/3scale/tf-vault-secret"
  context = module.user_label.context
  write   = true
  path    = "some/path/in/vault"
  value   = jsonencode({
    "key1" = some_resource.some_sensible_attr,
    "key2" = some_resource.some_other_sensible_attr,
  })
}
```

### Read

All the options available for write operations are available for read as well. Just invoke the module with `write` set to `false` (or without setting it as `false` is the default value) and without `value`. Some examples:

```
module "vault_secret" {
  source      = "git@github.com:3scale/tf-vault-secret.git?ref=tags/0.1.0"
  scope       = "teams"
  owner       = "operations"
  environment = local.environment
  project     = local.project
  workload    = local.workload
  type        = "some-type"
}
```

```
module "label" {
  source      = "git@github.com:3scale/tf-aws-label.git?ref=tags/0.1.1"
  environment = local.environment
  project     = local.project
  workload    = local.workload
  type        = "some-type"
  tf_config   = local.tf_config
}

module "vault_secret" {
  source  = "git@github.com:3scale/tf-vault-secret.git?ref=tags/0.1.0"
  context = module.user_label.context
  scope   = "teams"
  owner   = "operations"
}
```

```
module "vault_secret" {
  source  = "git@github.com:3scale/tf-vault-secret.git?ref=tags/0.1.0"
  path    = "some/path/in/vault"
}
```

## Outputs

Outputs are only relevant when `write` is `false`, in which case the module functions like a data.

| Output | Description |
|--------|-------------|
| value  | The sensitive value stored at the given Vaut path |
| path   | The full Vault path were the value is stored |
