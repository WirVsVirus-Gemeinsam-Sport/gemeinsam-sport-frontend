defmodule GemeinsamSportFrontend.RoomRegistry do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def register(id) do
    Registry.register(__MODULE__, id, [])
  end

  def get_room(id) do
    case Registry.lookup(__MODULE__, id) |> IO.inspect(label: "lookup:") do
      [{pid, _}] ->
        pid
      _ ->
        {pid, _} = GemeinsamSportFrontend.RoomManager.create_room(id)
        pid
    end
  end

  def init([]) do
    Registry.start_link(keys: :unique, name: __MODULE__)
    {:ok, []}
  end
end
