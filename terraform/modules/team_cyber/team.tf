variable "mount_path" {
  type = string
}

locals {
  team_name = "cyber"
}

resource "vault_policy" "team_policy" {
  name   = "policy-${local.team_name}"
  policy = <<EOT
path "${local.team_name}/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "${local.team_name}/metadata/*" {
  capabilities = ["list", "delete"]
}
EOT
}

resource "vault_approle_auth_backend_role" "team_role" {
  backend        = "approle"
  role_name      = local.team_name
  token_policies = [vault_policy.team_policy.name]
  token_ttl      = "28000"
  token_max_ttl  = "259200"
}

resource "vault_approle_auth_backend_role_secret_id" "team_secret_id" {
  backend   = "approle"
  role_name = vault_approle_auth_backend_role.team_role.role_name
}

output "role_id" {
  value = vault_approle_auth_backend_role.team_role.role_id
}

output "secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.team_secret_id.secret_id
  sensitive = true
}
