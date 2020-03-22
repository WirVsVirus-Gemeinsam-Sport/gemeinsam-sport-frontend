// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.css'
import 'bootstrap'
import Vue from 'vue'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import "./workout-step"
import "./workout-display"

import {dataStore} from './datastore';

var app = new Vue({
    el: '#workout-view',
    data: {
      commonState: dataStore,
      editMode: false,
    },
    methods: {
      update(id, type, duration) {
        dataStore.update(id, type, duration)
      },
      remove(id) {
        dataStore.remove(id)
      },
      add() {
        dataStore.add()
      },
      startWorkout() {
        dataStore.startWorkout()
      }
    },
    computed: {
      workoutRunning() {
        return this.commonState.currentElapsed >= 0
      },
    }
})