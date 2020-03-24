defmodule GemeinsamSportFrontend.Room do
  use GenServer
  alias GemeinsamSportFrontend.Dispatcher
  alias GemeinsamSportFrontend.Repo

  defmodule State do
    defstruct room: nil, start_time: nil
  end

  def start_link(room \\ nil) do
    GenServer.start_link(__MODULE__, room)
  end

  def get_id(server) do
    GenServer.call(server, :get_id)
  end

  def set_workout(server, workout) do
    GenServer.cast(server, {:set_workout, workout})
  end

  def get_workout(server) do
    GenServer.call(server, :get_workout)
  end

  def start_workout(server) do
    GenServer.cast(server, :start_workout)
  end

  defp get_workout_length(workout) do
    duration_in_seconds = workout
      |> Enum.map(fn %{duration: duration} -> duration end)
      |> Enum.sum()

    duration_in_seconds * 1_000
  end

  def init(room) do
    GemeinsamSportFrontend.RoomRegistry.register(room.id)
    {:ok, %State{
      room: room,
    }}
  end

  def handle_call(:get_id, _from, state) do
    {:reply, state.room.id, state}
  end

  def handle_call(:get_workout, _from, state) do
    {:reply, state.room.workout_steps, state}
  end

  def handle_cast({:set_workout, workout_steps}, state) do
    Dispatcher.notify({:room, state.room.id}, {:workout_updated, workout_steps})
    room = GemeinsamSportFrontend.Schema.Room.changeset(state.room, %{workout_steps: workout_steps})
      |> Repo.update!()
    {:noreply, %State{state | room: room}}
  end

  def handle_cast(:start_workout, state) do
    send(self(), :tick)
    {:noreply, %State{state | start_time: :erlang.monotonic_time()}}
  end

  def handle_info(:tick, state) do
    elapsed = :erlang.monotonic_time() - state.start_time
    elapsed_milliseconds = :erlang.convert_time_unit(elapsed, :native, :millisecond)
    Dispatcher.notify({:room, state.room.id}, {:elapsed, elapsed_milliseconds})

    state = case get_workout_length(state.room.workout_steps) > elapsed_milliseconds do
      true ->
        Process.send_after(self(), :tick, 1_000)
        state
      false ->
        Dispatcher.notify({:room, state.room.id}, {:elapsed, nil})
        %State{state | start_time: nil}
    end
    {:noreply, state}
  end
end
