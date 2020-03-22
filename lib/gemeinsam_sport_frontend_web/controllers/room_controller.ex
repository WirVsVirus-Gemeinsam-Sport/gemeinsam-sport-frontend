defmodule GemeinsamSportFrontendWeb.RoomController do
  use GemeinsamSportFrontendWeb, :controller

  def index(conn, _params) do
    {_pid, room_id} = GemeinsamSportFrontend.RoomManager.create_room()
    redirect(conn, to: "/#{room_id}")
  end

  def show(conn, %{"id" => id}) do
    room = GemeinsamSportFrontend.RoomRegistry.get_room(id)
    render(conn, "room.html", id: id, workout: GemeinsamSportFrontend.Room.get_workout(room))
  end
end
