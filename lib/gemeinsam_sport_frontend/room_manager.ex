defmodule GemeinsamSportFrontend.RoomManager do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def create_room(id \\ nil) do
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, {GemeinsamSportFrontend.Room, id})
    {pid, GemeinsamSportFrontend.Room.get_id(pid)}
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
