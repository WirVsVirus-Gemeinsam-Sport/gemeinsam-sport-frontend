defmodule GemeinsamSportFrontendWeb.RoomChannel do
  use Phoenix.Channel
  alias GemeinsamSportFrontend.Room
  alias GemeinsamSportFrontend.RoomRegistry

  def join("room:" <> room_id, _message, socket) do
    room = RoomRegistry.get_room(room_id)
    GemeinsamSportFrontend.Dispatcher.register({:room, room_id})
    socket = assign(socket, :room, room)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("updated_workout", %{"new_workout" => workout}, socket) do
    room = socket.assigns[:room]
    Room.set_workout(room, workout)
    {:noreply, socket}
  end

  def handle_in("start", _, socket) do
    room = socket.assigns[:room]
    Room.start_workout(room)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    # quick and ugly for now...
    room = socket.assigns[:room]
    broadcast!(socket, "updated_workout", %{"new_workout" => Room.get_workout(room)})

    {:noreply, socket}
  end

  def handle_info({{:room, _room_id}, {:workout_updated, workout}}, socket) do
    broadcast!(socket, "updated_workout", %{"new_workout" => workout})
    {:noreply, socket}
  end

  def handle_info({{:room, _room_id}, {:elapsed, milliseconds}}, socket) do
    broadcast!(socket, "elapsed", %{"elapsed_milliseconds" => milliseconds})
    {:noreply, socket}
  end
end
