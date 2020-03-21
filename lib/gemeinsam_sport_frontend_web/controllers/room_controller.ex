defmodule GemeinsamSportFrontendWeb.RoomController do
  use GemeinsamSportFrontendWeb, :controller

  def index(conn, _params) do
    room_id = GemeinsamSportFrontend.RoomManager.create_room()
    redirect(conn, to: "/#{room_id}")
  end

  def show(conn, %{"id" => id}) do
    render(conn, "room.html", room: GemeinsamSportFrontend.RoomManager.get_room(id))
  end
end
