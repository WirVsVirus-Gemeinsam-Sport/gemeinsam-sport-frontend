import Vue from 'vue';

Vue.component('workout-display', {
    template: `
    <div>
        <div class="past">
            <div v-if="stepsBeforeCurrent.length > 0">Past:</div>
            <div v-for="step in stepsBeforeCurrent" :key="step.id">
                <div class="text-muted">
                    {{step.type}} -- {{step.duration}}s
                </div>
            </div>
        </div>
        <div class="active" v-if="activeStep">
            <div class="active-type">{{activeStep.type}}</div>
            <div class="active-countdown">{{activeStep.remaining}}s</div>
        </div>
        <div class="upcoming">
            <div v-if="stepsAfterCurrent.length > 0">Upcoming:</div>
            <div v-for="step in stepsAfterCurrent" :key="step.id">
                <div class="text-muted">
                    {{step.type}} -- {{step.duration}}s
                </div>
            </div>
        </div>
    </div>
    `,
    props: ['steps', 'elapsed'],
    computed: {
        currentlyActiveStepId() {
            let elapsed = this.elapsed
            for (const step of this.steps) {
                if (step.duration > elapsed) {
                    return step.id
                } else {
                    elapsed -= step.duration
                }
            }
        },
        stepsWithRemainingTime() {
            let elapsed = this.elapsed

            const stepsWithRemainingTime = [];
            for (const step of this.steps) {
                const stepWithRemainingTime = {
                    id: step.id,
                    type: step.type,
                    duration: step.duration,
                    elapsed: Math.floor(Math.max(0, Math.min(elapsed, step.duration))),
                }
                stepWithRemainingTime.remaining = step.duration - stepWithRemainingTime.elapsed
                stepsWithRemainingTime.push(stepWithRemainingTime)
                elapsed -= step.duration
            }

            return stepsWithRemainingTime
        },
        stepsBeforeCurrent() {
            return this.stepsWithRemainingTime.filter(step => step.remaining == 0)
        },
        stepsAfterCurrent() {
            return this.stepsWithRemainingTime.filter(step => step.duration == step.remaining)
        },
        activeStep() {
            return this.stepsWithRemainingTime.find(step => step.id == this.currentlyActiveStepId)
        }
    }
})