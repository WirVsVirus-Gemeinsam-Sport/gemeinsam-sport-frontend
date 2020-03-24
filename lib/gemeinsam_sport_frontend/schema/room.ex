defmodule GemeinsamSportFrontend.Schema.Room do
  use GemeinsamSportFrontend.Schema
  alias GemeinsamSportFrontend.Schema.WorkoutStep

  schema "rooms" do
    has_many :workout_steps, WorkoutStep
  end

  def changeset(room, params \\ %{}) do
    room
    |> Ecto.Changeset.cast(params, [])
    |> Ecto.Changeset.cast_assoc(:workout_steps, with: &GemeinsamSportFrontend.Schema.WorkoutStep.changeset/2)
  end
end
