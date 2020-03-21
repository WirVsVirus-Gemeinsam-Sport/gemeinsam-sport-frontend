defmodule GemeinsamSportFrontendWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> _private_room_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in(type = "updated_workout", msg, socket) do
    IO.inspect(socket, label: "socket:")
    broadcast!(socket, type, msg)
    {:noreply, socket}
  end
end
