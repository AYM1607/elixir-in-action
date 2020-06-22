defmodule Todo.Cache do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_todo_server} = Todo.Server.start()

        {
          :reply,
          new_todo_server,
          Map.put(todo_servers, todo_list_name, new_todo_server)
        }
    end
  end
end
