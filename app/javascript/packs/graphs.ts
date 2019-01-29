/* eslint no-console: 0 */

import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.querySelector('#series-graph');
  const app = new Vue({
    el,
    render: h => h(App)
  })
})




