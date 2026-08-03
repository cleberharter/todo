## Plano: CI/CD com GitHub Actions + Azure (App Service, Static Web Apps, Terraform)

Pipeline de CI (build/test em PRs) + CD (deploy automático) para 3 ambientes — staging, hml, production —
provisionados via Terraform, com backend (.NET) em Azure App Service (container via ACR) e frontend
(React/Vite) em Azure Static Web Apps. Auth no Azure via Service Principal (client secret em GitHub Secrets).

### Decisões confirmadas
- Backend: Azure App Service (Web App for Containers), imagem publicada no Azure Container Registry (ACR).
- Frontend: Azure Static Web Apps (build direto do source, sem Docker — Dockerfile/nginx.conf atuais continuam servindo só para `docker compose` local).
- Ambientes: staging, hml, production.
- Mapeamento branch → ambiente: `feature/**` → staging | `staging` → hml | `main` → production.
- Auth GitHub Actions → Azure: Service Principal com client secret (não OIDC).
- IaC: Terraform (não Bicep).
- CI de PR: workflow separado de build+test antes do merge.
- Testes: projeto xUnit para o backend.

### Implementado
- **Backend**: CORS configurável via `Cors:AllowedOrigins` (appsettings por ambiente: Staging/Hml/Production).
- **Frontend**: `VITE_API_URL` configurável via variável de ambiente (`.env.example`).
- **Testes**: `backend/TodoApi.Tests` (xUnit) cobrindo `TodoService`.
- **Infra (Terraform)**: `infra/shared` (Resource Group + ACR) e `infra/environments` (App Service + Static Web App, parametrizado por `envs/*.tfvars`).
- **Workflows GitHub Actions**: `ci.yml` (build+test em PRs), `deploy.yml` (reusável), `deploy-staging.yml`, `deploy-hml.yml`, `deploy-production.yml`, `infra.yml` (Terraform plan/apply manual).

### Pré-requisitos manuais (fora do pipeline)
1. Criar Service Principal no Azure (`az ad sp create-for-rbac`) com role Contributor; salvar `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` como GitHub Secrets.
2. Criar manualmente (uma vez) a Storage Account + Blob Container para o remote state do Terraform, e os GitHub Variables `TFSTATE_RESOURCE_GROUP_NAME`, `TFSTATE_STORAGE_ACCOUNT_NAME`, `TFSTATE_CONTAINER_NAME`.
3. Criar GitHub Environments `staging`, `hml`, `production` (+ `shared` para o stack compartilhado), com required reviewers na `production`.
4. Após o primeiro `apply` do stack `shared`/ambientes, cadastrar o secret `AZURE_STATIC_WEB_APPS_API_TOKEN` por ambiente (valor do output `static_web_app_api_key`).

### Verificação
1. `terraform plan` em `infra/shared` e `infra/environments` sem erros.
2. `dotnet test backend/TodoApi.Tests` passando localmente.
3. PR de teste → `ci.yml` roda e passa antes do merge.
4. Push em `feature/*` → `deploy-staging.yml` roda; validar App Service e Static Web App de staging.
5. Merge em `staging` → `deploy-hml.yml` roda.
6. Merge em `main` → `deploy-production.yml` aguarda aprovação do GitHub Environment.

### Further considerations em aberto
1. Bootstrap do Terraform state é manual — avaliar script versionado (`infra/bootstrap.sh`/`.ps1`).
2. Modelo de branch é uma versão simplificada de git-flow (`feature/**`, `staging`, `main`) — confirmar se é definitivo.
3. ACR único compartilhado entre os 3 ambientes (assumido) vs. um ACR por ambiente.
