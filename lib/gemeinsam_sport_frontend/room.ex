defmodule GemeinsamSportFrontend.Room do
  use GenServer
  alias GemeinsamSportFrontend.Dispatcher

  defmodule State do
    defstruct id: nil, workout: nil, start_time: nil
  end

  def start_link(id \\ nil) do
    GenServer.start_link(__MODULE__, id)
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
      |> Enum.map(fn %{"duration" => duration} -> duration end)
      |> Enum.sum()

    duration_in_seconds * 1_000
  end

  def init(id) do
    id = case id do
      nil -> UUID.uuid1()
      id -> id
    end
    GemeinsamSportFrontend.RoomRegistry.register(id)
    {:ok, %State{
      id: id,
      workout: []
    }}
  end

  def handle_call(:get_id, _from, state = %State{id: id}) do
    {:reply, id, state}
  end

  def handle_call(:get_workout, _from, state = %State{workout: workout}) do
    {:reply, workout, state}
  end

  def handle_cast({:set_workout, workout}, state = %State{id: id}) do
    Dispatcher.notify({:room, id}, {:workout_updated, workout})
    {:noreply, %State{state | workout: workout}}
  end

  def handle_cast(:start_workout, state) do
    send(self(), :tick)
    {:noreply, %State{state | start_time: :erlang.monotonic_time()}}
  end

  def handle_info(:tick, state) do
    elapsed = :erlang.monotonic_time() - state.start_time
    elapsed_milliseconds = :erlang.convert_time_unit(elapsed, :native, :millisecond)
    Dispatcher.notify({:room, state.id}, {:elapsed, elapsed_milliseconds})

    state = case get_workout_length(state.workout) > elapsed_milliseconds do
      true ->
        Process.send_after(self(), :tick, 1_000)
        state
      false ->
        Dispatcher.notify({:room, state.id}, {:elapsed, nil})
        %State{state | start_time: nil}
    end
    {:noreply, state}
  end
end
