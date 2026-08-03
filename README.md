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
