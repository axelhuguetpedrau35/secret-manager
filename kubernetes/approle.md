## AppRole OpenBao : Rôles et Secrets ID par Équipe

Dans le cadre de la gestion fine des accès via OpenBao (Vault Community), chaque équipe dispose de ses propres identifiants AppRole. Ces identifiants permettent une authentification automatisée et sécurisée pour récupérer les secrets nécessaires à leurs workflows.

| Équipe      | `role_id`      | `secret_id`        |
|-------------|----------------|--------------------|
| **Cyber**   | `fake_role`    | `fake_secret`      |
| **Hosting** | `fake_role`    | `fake_secret`      |
| **Réseaux** | `fake_role`    | `fake_secret`      |

---

### À quoi servent ces identifiants ?

- **`role_id`** : Identifiant statique public utilisé pour identifier le rôle AppRole attribué à une équipe.
- **`secret_id`** : Jeton dynamique à durée de vie limitée, généré manuellement ou via API, associé au `role_id` pour obtenir un `client_token`. 

L'association des deux permet à un script ou une application d'obtenir un **token d'accès** limité au périmètre de l'équipe concernée. Ce mécanisme assure :
- Une séparation stricte des permissions par équipe
- Une rotation facile des `secret_id`
- Une intégration sécurisée dans des pipelines (CI/CD, scripts de monitoring, etc.)

---


