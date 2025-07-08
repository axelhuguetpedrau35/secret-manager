## AppRole OpenBao : Rôles et Secrets ID par Équipe

Dans le cadre de la gestion fine des accès via OpenBao (Vault Community), chaque équipe dispose de ses propres identifiants AppRole. Ces identifiants permettent une authentification automatisée et sécurisée pour récupérer les secrets nécessaires à leurs workflows.

| Équipe      | `role_id`                                 | `secret_id`                                 |
|-------------|-------------------------------------------|---------------------------------------------|
| **Cyber**   | `f89ac3b7-ef4d-7328-1ead-46271202ffb9`    | `e2baba80-c426-b89a-d827-ac9b5f176623`      |
| **Hosting** | `96662328-c524-a9dd-0e1f-1da4d11baalb`    | `9728b4e4-61e7-9e4a-378a-c51ee730265d`      |
| **Réseaux** | `b5384088-65ee-cbac-8263-9102cc817d3c`    | `3650f7aa-1748-1dd3-c3da-e6d48029c40d`      |

---

### À quoi servent ces identifiants ?

- **`role_id`** : Identifiant statique public utilisé pour identifier le rôle AppRole attribué à une équipe.
- **`secret_id`** : Jeton dynamique à durée de vie limitée, généré manuellement ou via API, associé au `role_id` pour obtenir un `client_token`.

L'association des deux permet à un script ou une application d'obtenir un **token d'accès** limité au périmètre de l'équipe concernée. Ce mécanisme assure :
- Une séparation stricte des permissions par équipe
- Une rotation facile des `secret_id`
- Une intégration sécurisée dans des pipelines (CI/CD, scripts de monitoring, etc.)

---


