defmodule KeyValueStore do
  use GenServer

  def start do
    GenServer.start(KeyValueStore, nil)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
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
  def handle_call({:get, key}, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_info(:cleanup, state) do
    IO.puts("Performing cleanup...")
    {:noreply, state}
  end
end
