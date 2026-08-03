using TodoApi.Models;

namespace TodoApi.Services;

// Simple thread-safe in-memory store; data resets whenever the API restarts.
public class TodoService : ITodoService
{
    private readonly List<TodoItem> _items = new()
    {
        new TodoItem { Id = 1, Title = "Aprender ASP.NET Core", IsDone = false },
        new TodoItem { Id = 2, Title = "Aprender React", IsDone = false },
    };
    private readonly object _lock = new();
    private int _nextId = 3;

    public IEnumerable<TodoItem> GetAll()
    {
        lock (_lock)
        {
            return _items.ToList();
        }
    }

    public TodoItem? GetById(int id)
    {
        lock (_lock)
        {
            return _items.FirstOrDefault(i => i.Id == id);
        }
    }

    public TodoItem Create(TodoItem item)
    {
        lock (_lock)
        {
            item.Id = _nextId++;
            _items.Add(item);
            return item;
        }
    }

    public bool Update(int id, TodoItem item)
    {
        lock (_lock)
        {
            var existing = _items.FirstOrDefault(i => i.Id == id);
            if (existing is null) return false;

            existing.Title = item.Title;
            existing.IsDone = item.IsDone;
            return true;
        }
    }

    public bool Delete(int id)
    {
        lock (_lock)
        {
            var existing = _items.FirstOrDefault(i => i.Id == id);
            if (existing is null) return false;

            _items.Remove(existing);
            return true;
        }
    }
}
