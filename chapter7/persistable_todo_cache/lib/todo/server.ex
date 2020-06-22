defmodule Todo.Server do
  use GenServer

  def start(todo_list_name) do
    GenServer.start(__MODULE__, todo_list_name)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete_entry, entry_id})
  end

  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:update_entry, entry_id, updater_fun})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @impl true
  def init(todo_list_name) do
    send(self(), :init_data)
    {:ok, {todo_list_name, nil}}
  end

  @impl true
  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    # Get the new todo list.
    new_list = Todo.List.add_entry(todo_list, entry)
    # Persist the new list to disk.
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_cast({:update_entry, entry_id, updater_fun}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, updater_fun)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_call({:entries, date}, _, {_, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state}
  end

  @impl true
  def handle_info(:init_data, {name, _}) do
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new()}}
  end
end
