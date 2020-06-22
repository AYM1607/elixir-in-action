defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
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
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl true
  def handle_cast({:add_entry, entry}, state) do
    {:noreply, Todo.List.add_entry(state, entry)}
  end

  @impl true
  def handle_cast({:delete_entry, entry_id}, state) do
    {:noreply, Todo.List.delete_entry(state, entry_id)}
  end

  @impl true
  def handle_cast({:update_entry, entry_id, updater_fun}, state) do
    {:noreply, Todo.List.update_entry(state, entry_id, updater_fun)}
  end

  @impl true
  def handle_call({:entries, date}, _, state) do
    {:reply, Todo.List.entries(state, date), state}
  end
end
