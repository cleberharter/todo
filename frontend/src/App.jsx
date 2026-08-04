import { useEffect, useState } from 'react'
import './App.css'
import { getTodos, createTodo, updateTodo, deleteTodo } from './api'

function App() {
  const [todos, setTodos] = useState([])
  const [title, setTitle] = useState('')
  const [error, setError] = useState('')

  useEffect(() => {
    loadTodos()
  }, [])

  async function loadTodos() {
    try {
      setTodos(await getTodos())
    } catch (err) {
      setError(err.message)
    }
  }

  async function handleSubmit(e) {
    e.preventDefault()
    if (!title.trim()) return
    try {
      await createTodo(title.trim())
      setTitle('')
      await loadTodos()
    } catch (err) {
      setError(err.message)
    }
  }

  async function toggleDone(todo) {
    try {
      await updateTodo(todo.id, { ...todo, isDone: !todo.isDone })
      await loadTodos()
    } catch (err) {
      setError(err.message)
    }
  }

  async function removeTodo(id) {
    try {
      await deleteTodo(id)
      await loadTodos()
    } catch (err) {
      setError(err.message)
    }
  }

  return (
    <div className="app">
      <h1>Minhas Tarefas 13</h1>

      <form className="todo-form" onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Nova tarefa..."
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <button type="submit">Adicionar</button>
      </form>

      {error && <p className="status">{error}</p>}

      <ul className="todo-list">
        {todos.map((todo) => (
          <li key={todo.id} className={`todo-item ${todo.isDone ? 'done' : ''}`}>
            <input
              type="checkbox"
              checked={todo.isDone}
              onChange={() => toggleDone(todo)}
            />
            <span>{todo.title}</span>
            <button onClick={() => removeTodo(todo.id)}>Excluir</button>
          </li>
        ))}
      </ul>

      {todos.length === 0 && !error && <p className="status">Nenhuma tarefa ainda.</p>}
    </div>
  )
}

export default App
