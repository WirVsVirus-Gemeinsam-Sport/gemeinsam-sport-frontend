defmodule GemeinsamSportFrontend.Dispatcher do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def register(topic) do
    Registry.register(__MODULE__, topic, [])
  end

  def notify(topic, term) do
    Registry.dispatch(__MODULE__, topic, fn entries ->
      for {pid, _} <- entries do
        send(pid, {topic, term})
      end
    end)
  end

  def init([]) do
    Registry.start_link(keys: :duplicate, name: __MODULE__)
    {:ok, []}
  end
end
