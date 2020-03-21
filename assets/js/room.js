import socket from "./socket"

const workoutInput = document.getElementById('workout_description');

const channel = socket.channel("room:" + roomId, {})
channel.on("updated_workout", msg => workoutInput.value = msg.new_workout )
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

function setWorkout(value) {
    console.log('sending new workout', value)
    channel.push("updated_workout", {new_workout: value}, 10000)
        .receive("ok", (msg) => console.log("created message", msg) )
        .receive("error", (reasons) => console.log("create failed", reasons) )
        .receive("timeout", () => console.log("Networking issue...") )
}


workoutInput.addEventListener('input', event => {
    setWorkout(event.target.value)
})