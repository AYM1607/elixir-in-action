defmodule KeyValueStore do
  use GenServer

  def start do
    # At compile time, __MODULE__ is replaced with KeyValueStore
    # This makes refactoring easier.
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl true
  def init(_) do
    # Set up the process to send itself a cleanup message every 5 secs.
    :timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_info(:cleanup, state) do
    IO.puts("Performing cleanup...")
    {:noreply, state}
  end
end
