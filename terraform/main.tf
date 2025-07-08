terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address      = "http://<ip>:32123"
  token        = var.vault_token
}

# Mounts KV par équipe
resource "vault_mount" "teamA_kv" {
  path        = "cyber"
  type        = "kv"
  description = "KV engine for Cyber team"
  options     = {
    version = "2"
  }
}

resource "vault_mount" "teamB_kv" {
  path        = "hosting"
  type        = "kv"
  description = "KV engine for Hosting team"
  options     = {
    version = "2"
  }
}

resource "vault_mount" "teamC_kv" {
  path        = "reseaux"
  type        = "kv"
  description = "KV engine for Reseaux team"
  options     = {
    version = "2"
  }
}

# Secrets initiaux (test)
resource "vault_kv_secret_v2" "teamA_secret" {
  mount     = vault_mount.cyber_kv.path
  name      = "cybertest"
  data_json = jsonencode({
    initial_key = "cyber_value"
  })
  cas = 1
}

resource "vault_kv_secret_v2" "teamB_secret" {
  mount     = vault_mount.hosting_kv.path
  name      = "hostingtest"
  data_json = jsonencode({
    initial_key = "hosting_value"
  })
  cas = 1
}

resource "vault_kv_secret_v2" "teamC_secret" {
  mount     = vault_mount.reseaux_kv.path
  name      = "reseauxtest"
  data_json = jsonencode({
    initial_key = "reseaux_value"
  })
  cas = 1
}

# Modules des trois équipes
module "cyber_team" {
  source     = "./modules/teamA"
  mount_path = vault_mount.cyber_kv.path
}

module "hosting_team" {
  source     = "./modules/teamB"
  mount_path = vault_mount.hosting_kv.path
}

module "reseaux_team" {
  source     = "./modules/teamC"
  mount_path = vault_mount.reseaux_kv.path
}

# Outputs pour automatisation (récup AppRole)
output "teamA_role_id" {
  value = module.teamA.role_id
}
output "teamA_secret_id" {
  value     = module.teamA.secret_id
  sensitive = true
}
output "teamB_role_id" {
  value = module.hosting_team.role_id
}
output "teamB_secret_id" {
  value     = module.teamB.secret_id
  sensitive = true
}
output "teamC_role_id" {
  value = module.teamC.role_id
}
output "teamC_secret_id" {
  value     = module.teamC.secret_id
  sensitive = true
}
