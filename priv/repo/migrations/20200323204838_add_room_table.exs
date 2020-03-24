defmodule GemeinsamSportFrontend.Repo.Migrations.AddRoomTable do
  use Ecto.Migration

  def change do
    create table("rooms", primary_key: false) do
      add :id, :uuid, primary_key: true
    end

    create table("workout_steps", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :duration, :integer
      add :room_id, references(:rooms, type: :binary_id)
    end
  end
end
