defmodule GemeinsamSportFrontend.RoomManager do
  use DynamicSupervisor
  alias GemeinsamSportFrontend.Repo
  alias GemeinsamSportFrontend.RoomRegistry
  alias GemeinsamSportFrontend.Schema.Room

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  defp spawn_room(room) do
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, {GemeinsamSportFrontend.Room, room})
    pid
  end

  def create_room() do
    room = Repo.insert!(Room.changeset(
      %Room{},
      %{
        workout_steps: [
          %{type: "Warmup", duration: 5},
          %{type: "Do a plank", duration: 30},
          %{type: "Break", duration: 10},
          %{type: "Push Ups", duration: 30},
        ]
      }))
      spawn_room(room)
  end

  def get_room(id) do
    case RoomRegistry.get_live_room(id) do
      nil -> spawn_room(Repo.get!(Room, id) |> Repo.preload(:workout_steps))
      room -> room
    end
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
