defmodule GemeinsamSportFrontend.RoomManager do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def create_room() do
    GenServer.call(__MODULE__, :create_room)
  end

  def get_room(id) do
    %{ id: id, workout: "do a plank!" }
  end

  def init([]) do
    {:ok, %{}}
  end

  def handle_call(:create_room, _from, current_rooms) do
    uuid = UUID.uuid1()
    current_rooms = Map.put(current_rooms, uuid, %{})

    {:reply, uuid, current_rooms}
  end
end
