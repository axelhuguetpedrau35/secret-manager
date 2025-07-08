terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address      = "http://10.201.201.206:31823"
  token        = var.vault_token
}

# Mounts KV par équipe
resource "vault_mount" "cyber_kv" {
  path        = "cyber"
  type        = "kv"
  description = "KV engine for Cyber team"
  options     = {
    version = "2"
  }
}

resource "vault_mount" "hosting_kv" {
  path        = "hosting"
  type        = "kv"
  description = "KV engine for Hosting team"
  options     = {
    version = "2"
  }
}

resource "vault_mount" "reseaux_kv" {
  path        = "reseaux"
  type        = "kv"
  description = "KV engine for Reseaux team"
  options     = {
    version = "2"
  }
}

# Secrets initiaux (test)
resource "vault_kv_secret_v2" "cyber_secret" {
  mount     = vault_mount.cyber_kv.path
  name      = "cybertest"
  data_json = jsonencode({
    initial_key = "cyber_value"
  })
  cas = 1
}

resource "vault_kv_secret_v2" "hosting_secret" {
  mount     = vault_mount.hosting_kv.path
  name      = "hostingtest"
  data_json = jsonencode({
    initial_key = "hosting_value"
  })
  cas = 1
}

resource "vault_kv_secret_v2" "reseaux_secret" {
  mount     = vault_mount.reseaux_kv.path
  name      = "reseauxtest"
  data_json = jsonencode({
    initial_key = "reseaux_value"
  })
  cas = 1
}

# Modules des trois équipes
module "cyber_team" {
  source     = "./modules/team_cyber"
  mount_path = vault_mount.cyber_kv.path
}

module "hosting_team" {
  source     = "./modules/team_hosting"
  mount_path = vault_mount.hosting_kv.path
}

module "reseaux_team" {
  source     = "./modules/team_reseaux"
  mount_path = vault_mount.reseaux_kv.path
}

# Outputs pour automatisation (récup AppRole)
output "cyber_role_id" {
  value = module.cyber_team.role_id
}
output "cyber_secret_id" {
  value     = module.cyber_team.secret_id
  sensitive = true
}
output "hosting_role_id" {
  value = module.hosting_team.role_id
}
output "hosting_secret_id" {
  value     = module.hosting_team.secret_id
  sensitive = true
}
output "reseaux_role_id" {
  value = module.reseaux_team.role_id
}
output "reseaux_secret_id" {
  value     = module.reseaux_team.secret_id
  sensitive = true
}
