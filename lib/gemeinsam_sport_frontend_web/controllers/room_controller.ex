defmodule GemeinsamSportFrontendWeb.RoomController do
  use GemeinsamSportFrontendWeb, :controller


  def new(conn, _params) do
    pid = GemeinsamSportFrontend.RoomManager.create_room()
    room_id = GemeinsamSportFrontend.Room.get_id(pid)
    redirect(conn, to: "/#{room_id}")
  end

  def show(conn, %{"id" => id}) do
    room = GemeinsamSportFrontend.RoomManager.get_room(id)
    render(conn, "room.html", id: id, workout: GemeinsamSportFrontend.Room.get_workout(room))
  end
end
