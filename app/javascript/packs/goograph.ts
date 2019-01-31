import Vue from 'vue'
import GooChart from '../views/goochart.vue'

Vue.config.productionTip = false

const element = document.getElementById('series-graph');
const seriesId = element.dataset.seriesid;
const app = new Vue({
  el: element,
  render: h => h(GooChart, {
    props: { realAssetId: seriesId }
  }),
});

