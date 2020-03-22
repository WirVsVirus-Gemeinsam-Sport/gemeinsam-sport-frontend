import socket from './socket'

class DataStore {
    constructor() {
        this.channel = socket.channel("room:" + roomId, {})
        this.channel.on("updated_workout", msg => this.workoutSteps = msg.new_workout )
        this.channel.on("elapsed", msg => this.currentElapsed = msg.elapsed_milliseconds / 1000.0)
        this.channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

        this.workoutSteps = [
            {id: 1, type: "Plank", duration: 10},
            {id: 2, type: "Pushup", duration: 20},
            {id: 3, type: "Break", duration: 10},
        ]

        this.currentElapsed = -1
    }

    push(topic, data = {}) {
        this.channel.push(topic, data, 10000)
            .receive("ok", (msg) => console.log("created message", msg) )
            .receive("error", (reasons) => console.log("create failed", reasons) )
            .receive("timeout", () => console.log("Networking issue...") )
    }

    sendUpdate() {
        console.log('sending new workout', this.workoutSteps)
        this.push("updated_workout", {new_workout: this.workoutSteps})
    }

    update(id, type, duration) {
        const itemToUpdate = this.workoutSteps.find(item => item.id == id)
        itemToUpdate.type = type
        itemToUpdate.duration = duration
        this.sendUpdate()
    }

    remove(id) {
        this.workoutSteps = this.workoutSteps.filter(step => step.id != id)
        this.sendUpdate()
    }

    add() {
        let nextId
        if (this.workoutSteps.length == 0) {
            nextId = 1
        } else {
            nextId = this.workoutSteps[this.workoutSteps.length - 1].id + 1
        } 
        this.workoutSteps.push({
            id: nextId,
            type: "Plank",
            duration: 10,
        })
        this.sendUpdate()
    }

    startWorkout() {
        this.push("start")
    }
}

export const dataStore = new DataStore()