defmodule GemeinsamSportFrontendWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> _private_room_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in(type = "updated_workout", msg, socket) do
    broadcast!(socket, type, msg)
    {:noreply, socket}
  end

  def handle_in("start", _, socket) do
    start_time = :erlang.monotonic_time()
    socket = assign(socket, :start_time, start_time)
    send(self(), :tick)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    current_time = :erlang.monotonic_time()
    elapsed = current_time - socket.assigns[:start_time]
    elapsed_milliseconds = :erlang.convert_time_unit(elapsed, :native, :millisecond)
    broadcast!(socket, "elapsed", %{elapsed_milliseconds: elapsed_milliseconds})

    Process.send_after(self(), :tick, 1_000)

    {:noreply, socket}
  end
end
