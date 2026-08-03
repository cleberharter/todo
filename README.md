# ToDo — Projeto Básico (Backend .NET + Frontend React)

Aplicação simples de lista de tarefas com:
- **Backend**: ASP.NET Core Web API (.NET 9), dados em memória (sem banco de dados).
- **Frontend**: React 18 + Vite, JavaScript puro.

## Estrutura

```
backend/TodoApi/    -> API .NET (porta 5140)
frontend/           -> App React (porta 5173)
```

## Como executar

### Backend
```powershell
cd backend/TodoApi
dotnet run
```
A API sobe em `http://localhost:5140` (Swagger em `http://localhost:5140/swagger`).

### Frontend
```powershell
cd frontend
npm install
npm run dev
```
O app abre em `http://localhost:5173`.

> Execute o backend e o frontend em terminais separados. O frontend já está configurado (CORS e URL da API) para conversar com o backend em `http://localhost:5140`.

### Docker

Também é possível rodar tudo em containers, sem instalar .NET ou Node localmente.

Subir os dois serviços com Docker Compose:
```powershell
docker compose up --build
```
- Backend: `http://localhost:5140` (Swagger em `http://localhost:5140/swagger`, disponível apenas em ambiente Development)
- Frontend: `http://localhost:5173`

Ou individualmente:
```powershell
docker build -t todo-backend ./backend/TodoApi
docker run -p 5140:5140 todo-backend

docker build -t todo-frontend ./frontend
docker run -p 5173:80 todo-frontend
```

## Endpoints da API

| Método | Rota                     | Descrição            |
|--------|--------------------------|-----------------------|
| GET    | /api/todoitems           | Lista todas as tarefas |
| GET    | /api/todoitems/{id}      | Busca uma tarefa       |
| POST   | /api/todoitems           | Cria uma tarefa        |
| PUT    | /api/todoitems/{id}      | Atualiza uma tarefa    |
| DELETE | /api/todoitems/{id}      | Remove uma tarefa      |

## Observação

Os dados ficam apenas em memória: reiniciar o backend reseta a lista de tarefas para os dois itens de exemplo.

## CI/CD

O projeto usa GitHub Actions com 3 ambientes no Azure (App Service + Static Web Apps, provisionados via Terraform):

| Branch        | Ambiente   |
|---------------|------------|
| `feature/**`  | staging    |
| `staging`     | hml        |
| `main`        | production |

- `.github/workflows/ci.yml` — build + testes em todo Pull Request.
- `.github/workflows/deploy-staging.yml`, `deploy-hml.yml`, `deploy-production.yml` — deploy automático por branch.
- `.github/workflows/infra.yml` — provisionamento manual da infraestrutura (Terraform, pasta `infra/`).

Detalhes completos do plano em [plans/ci-cd-github-actions-azure.md](plans/ci-cd-github-actions-azure.md).
Pendências manuais de configuração (Azure/GitHub) em [docs/pendencias-manuais.md](docs/pendencias-manuais.md).
