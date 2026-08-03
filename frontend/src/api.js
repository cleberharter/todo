const API_URL = 'http://localhost:5140/api/todoitems'

export async function getTodos() {
  const res = await fetch(API_URL)
  if (!res.ok) throw new Error('Falha ao buscar tarefas')
  return res.json()
}

export async function createTodo(title) {
  const res = await fetch(API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title, isDone: false }),
  })
  if (!res.ok) throw new Error('Falha ao criar tarefa')
  return res.json()
}

export async function updateTodo(id, todo) {
  const res = await fetch(`${API_URL}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(todo),
  })
  if (!res.ok) throw new Error('Falha ao atualizar tarefa')
}

export async function deleteTodo(id) {
  const res = await fetch(`${API_URL}/${id}`, { method: 'DELETE' })
  if (!res.ok) throw new Error('Falha ao excluir tarefa')
}
