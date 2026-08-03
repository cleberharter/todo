# Pendências manuais — CI/CD Azure

Passos que precisam ser feitos manualmente (fora dos workflows do GitHub Actions), pois exigem acesso a uma
subscription Azure real e criação de credenciais. Sem eles, [infra.yml](../.github/workflows/infra.yml) e
[deploy.yml](../.github/workflows/deploy.yml) falham.

## 1. Service Principal (autenticação Azure → GitHub Actions)

Usado pelo `azurerm` provider do Terraform (env vars `ARM_*`) e pelo `azure/login` no deploy.

```powershell
az account show --query id -o tsv
# copie o valor retornado e substitua <SUBSCRIPTION_ID> abaixo

az ad sp create-for-rbac --name "sp-todo-github-actions" --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

O comando retorna `appId`, `password` e `tenant`. Cadastre como **GitHub Secrets** (Settings → Secrets and
variables → Actions → Secrets):

| Secret                   | Valor                  |
|--------------------------|-------------------------|
| `AZURE_CLIENT_ID`        | `appId`                 |
| `AZURE_CLIENT_SECRET`    | `password`              |
| `AZURE_TENANT_ID`        | `tenant`                |
| `AZURE_SUBSCRIPTION_ID`  | ID da subscription      |

## 2. Storage Account para o remote state do Terraform

O Terraform não pode criar seu próprio backend (dependência circular), então a Storage Account que guarda o
`.tfstate` precisa existir antes do primeiro `terraform init` (ver [infra.yml](../.github/workflows/infra.yml)).

```powershell
az group create --name rg-todo-tfstate --location brazilsouth
az storage account create --name sttodotfstate --resource-group rg-todo-tfstate --sku Standard_LRS
az storage container create --name tfstate --account-name sttodotfstate
```

Cadastre como **GitHub Variables** (Settings → Secrets and variables → Actions → Variables):

| Variable                        | Valor                |
|----------------------------------|----------------------|
| `TFSTATE_RESOURCE_GROUP_NAME`    | `rg-todo-tfstate`    |
| `TFSTATE_STORAGE_ACCOUNT_NAME`   | `sttodotfstate`      |
| `TFSTATE_CONTAINER_NAME`         | `tfstate`            |

## 3. GitHub Environments

Criar em Settings → Environments: `shared`, `staging`, `hml`, `production`.

- Na `production`, configurar **required reviewers** para exigir aprovação manual antes do deploy
  ([deploy-production.yml](../.github/workflows/deploy-production.yml)).
- É nos Environments que entra o secret `AZURE_STATIC_WEB_APPS_API_TOKEN` (um valor diferente por ambiente,
  obtido no passo 5).

## 4. Provisionar a infraestrutura (ordem obrigatória)

1. Rodar [infra.yml](../.github/workflows/infra.yml) manualmente com `stack: shared`, `action: apply` → cria
   Resource Group + Azure Container Registry ([infra/shared/main.tf](../infra/shared/main.tf)).
2. Rodar `infra.yml` para `stack: staging`, depois `hml`, depois `production` (`action: apply`) → cria App
   Service + Static Web App de cada ambiente ([infra/environments/main.tf](../infra/environments/main.tf)),
   que dependem do output do stack `shared` via `terraform_remote_state`
   ([infra/environments/data.tf](../infra/environments/data.tf)).

## 5. Static Web Apps deployment token

Depois do apply de cada ambiente, pegar o output sensível `static_web_app_api_key`:

```powershell
terraform output -raw static_web_app_api_key
```

Cadastrar esse valor como o secret `AZURE_STATIC_WEB_APPS_API_TOKEN` do respectivo GitHub Environment
(`staging`, `hml`, `production`).

## 6. Atualizar CORS com a URL real do Static Web App

Depois de provisionado, pegar a URL (`static_web_app_hostname`) de cada ambiente e substituir os placeholders
`REPLACE-swa-*.azurestaticapps.net` em:
- [appsettings.Staging.json](../backend/TodoApi/appsettings.Staging.json)
- [appsettings.Hml.json](../backend/TodoApi/appsettings.Hml.json)
- [appsettings.Production.json](../backend/TodoApi/appsettings.Production.json)

Sem isso, o frontend recebe erro de CORS ao chamar a API.
