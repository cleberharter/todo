using TodoApi.Models;
using TodoApi.Services;
using Xunit;

namespace TodoApi.Tests;

public class TodoServiceTests
{
    [Fact]
    public void GetAll_ReturnsSeededItems()
    {
        var service = new TodoService();

        var items = service.GetAll();

        Assert.Equal(2, items.Count());
    }

    [Fact]
    public void Create_AddsItemAndAssignsId()
    {
        var service = new TodoService();

        var created = service.Create(new TodoItem { Title = "Nova tarefa" });

        Assert.True(created.Id > 0);
        Assert.Contains(service.GetAll(), i => i.Id == created.Id && i.Title == "Nova tarefa");
    }

    [Fact]
    public void GetById_UnknownId_ReturnsNull()
    {
        var service = new TodoService();

        var result = service.GetById(999);

        Assert.Null(result);
    }

    [Fact]
    public void Update_ExistingItem_ChangesTitleAndStatus()
    {
        var service = new TodoService();
        var created = service.Create(new TodoItem { Title = "Original" });

        var updated = service.Update(created.Id, new TodoItem { Title = "Atualizado", IsDone = true });

        Assert.True(updated);
        var item = service.GetById(created.Id);
        Assert.Equal("Atualizado", item!.Title);
        Assert.True(item.IsDone);
    }

    [Fact]
    public void Update_UnknownId_ReturnsFalse()
    {
        var service = new TodoService();

        var updated = service.Update(999, new TodoItem { Title = "X" });

        Assert.False(updated);
    }

    [Fact]
    public void Delete_ExistingItem_RemovesIt()
    {
        var service = new TodoService();
        var created = service.Create(new TodoItem { Title = "Para remover" });

        var deleted = service.Delete(created.Id);

        Assert.True(deleted);
        Assert.Null(service.GetById(created.Id));
    }

    [Fact]
    public void Delete_UnknownId_ReturnsFalse()
    {
        var service = new TodoService();

        var deleted = service.Delete(999);

        Assert.False(deleted);
    }
}
