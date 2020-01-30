output "value" {
  sensitive   = true
  value = var.write ? "{}" : data.vault_generic_secret.read[0].data_json
}

output "path" {
  value = local.full_path
}