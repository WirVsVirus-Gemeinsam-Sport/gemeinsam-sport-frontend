import Vue from 'vue';

Vue.component('workout-step', {
    template: `
        <div class="form-row align-items-center">
            <div class="col-7">
                <div class="input-group">
                    <input type="type" class="form-control" placeholder="Activity" list="activities" v-model="typeModel">
                    <datalist id="activities">
                        <option>Plank</option>
                        <option>Push up</option>
                        <option>Break</option>
                    </datalist>
                </div>
            </div>
            <div class="col-4">
                <div class="input-group">
                    <input type="text" class="form-control" id="inlineFormInputGroup" v-model="durationModel">
                    <div class="input-group-append">
                        <div class="input-group-text">s</div>
                    </div>
                </div>
            </div>
            <div class="col-1">
                <div class="input-group">
                <button type="button" class="btn btn-danger close" aria-label="Close" v-on:click="remove">
                    <span aria-hidden="true">&times;</span>
                </button>
                </div>
            </div>
        </div>
    `,
    props: ['type', 'duration'],
    methods: {
        remove() {
            this.$emit('removed')
        },
    },
    computed: {
        typeModel: {
            get() {
                return this.type
            },
            set(value) {
                this.$emit('updated', value, this.duration)
            },
        },
        durationModel: {
            get() {
                return this.duration
            },
            set(value) {
                this.$emit('updated', this.type, value)
            },
        },
    }
})