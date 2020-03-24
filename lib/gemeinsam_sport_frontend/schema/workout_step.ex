defmodule GemeinsamSportFrontend.Schema.WorkoutStep do
  use GemeinsamSportFrontend.Schema
  alias GemeinsamSportFrontend.Schema.Room

  schema "workout_steps" do
    field :type
    field :duration, :integer
    belongs_to :room, Room
  end

  def changeset(room, params \\ %{}) do
    room
    |> Ecto.Changeset.cast(params, [:type, :duration])
    |> Ecto.Changeset.validate_required([:type, :duration])
    |> Ecto.Changeset.cast_assoc(:room, with: &GemeinsamSportFrontend.Schema.Room.changeset/2)
  end
end
