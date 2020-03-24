defmodule GemeinsamSportFrontend.RoomRegistry do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def register(id) do
    Registry.register(__MODULE__, id, [])
  end

  def get_live_room(id) do
    case Registry.lookup(__MODULE__, id) do
      [{pid, _}] ->
        pid
      _ ->
        nil
    end
  end

  def init([]) do
    Registry.start_link(keys: :unique, name: __MODULE__)
    {:ok, []}
  end
end
