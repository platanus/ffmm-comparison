<template>
  <div class="chart" style="width:90%;margin: 0 auto;">
    <div>
      <label for="amount">Ingresa monto a invertir: $</label>
      <input type="number" name="amount" v-model="amount">
    </div>
    <br/>
    <div>Inversion inicial: ${{ formattedAmount }}</div>
    <div>Monto final: ${{ returns }}</div>
    <div>Comisiones: ${{ fees }}</div>
    <div>Quotas: {{ numQuotes }} </div>
    <br/>
    <div>Rentabilidad fondo: {{ rateOfReturn }}%</div>
    <div>Valor cuota{{ name }}</div>
    <GChart
      :settings=" {'packages':['annotatedtimeline']}"
      type="AnnotatedTimeLine"
      :data="chartData"
      :options="chartOptions"
      :events="chartEvents"
    />
  </div>
</template>

<script>
import { GChart } from "vue-google-charts";
import _ from 'lodash'

const formatter = new Intl.NumberFormat('el-CL', {
  style: 'currency',
  currency: 'CLP',
  minimumFractionDigits: 0
})

export default {
  name: "App",
  components: {
    GChart
  },
  props: {
    name: String,
    realAssetId: String,
  },
  data() {
    return {
      amount: 0,
      startRangeIndex: null,
      endRangeIndex: null,
      days: null,
      chartData: null,
      chartOptions: {
        chart: {
          title: "Company Performance",
          subtitle: "Sales, Expenses, and Profit: 2014-2017"
        },
        height: 400,
      },
      chartEvents: {
        rangechange: (e) => {
         this.setExtremes(e)
        },
      },
      error: null,
    };
  },
  created: function () {
    this.fetchDays();
  },
  methods: {
    fetchDays() {
      fetch(`https://fintual.cl/api/real_assets/${this.realAssetId}/days`)
      .then(data => data.json())
      .then(data => {
        this.days = data['data']
          .map(day => [new Date(Date.parse(day["attributes"]["date"])), day["attributes"]["price"], day['attributes']['fixed_fee'], day['attributes']['variable_fee']])
          .sort((a, b) => a[0] - b[0]);
        this.chartData = [['date', 'price']].concat(this.days.map(day=> [day[0], day[1]]) ); 
        if (this.days && this.days.length > 0) {
          this.startRangeIndex = 0;
          this.endRangeIndex = this.days.length - 1;
        } else {
          this.error = true;
        }
      });
    },

    setExtremes(e) {
      const startDate = e.start.getTime();
      const endDate = e.end.getTime();
      this.updateRangeIndexes(startDate, endDate);
    },

    getTimeFromIndex(index) {
      return this.days[index][0].getTime();
    },

    minDay(startIndex, currentIndex) {
      if (!startIndex) return currentIndex;
      return this.getTimeFromIndex(startIndex) < this.getTimeFromIndex(currentIndex) ?
             startIndex : currentIndex;
    },

    maxDay(endIndex, currentIndex) {
      if (!endIndex) return currentIndex;
      return this.getTimeFromIndex(endIndex) > this.getTimeFromIndex(currentIndex) ?
             endIndex : currentIndex;
    },

    updateRangeIndexes(startDate, endDate) {
      if (!startDate || !endDate) { return }
      let startIndex;
      let endIndex;
      for (let i = 0; i < this.days.length; i++) {
        const currentTime = this.getTimeFromIndex(i);
        if (!_.inRange(currentTime, startDate, endDate + 1)) { continue }
        startIndex = this.minDay(startIndex, i);
        endIndex = this.maxDay(endIndex, i);
      }
      this.startRangeIndex = startIndex;
      this.endRangeIndex = endIndex;
    },

    getPriceFromIndex(index) {
      if (this.days != null && index != null) {
        return this.days[index][1];
      }
      return 0;
    },

    calculateRateOfReturn() {
      const startPrice = this.getPriceFromIndex(this.startRangeIndex);
      const endPrice = this.getPriceFromIndex(this.endRangeIndex);
      const rate = ((endPrice - startPrice) / startPrice) * 100;
      return _.round(rate, 2);
    },
    
    getFeesFromIndex(index) {
      const day = this.days[index];
      return day[2] + day[3];
    },

    calculateFees() {
      let fees = 0;
      if (this.startRangeIndex < this.endRangeIndex) {
        for (let i = this.startRangeIndex; i < this.endRangeIndex; i++) {
          fees += this.numQuotes * this.getPriceFromIndex(i) * this.getFeesFromIndex(i);
        }
      } 
      return fees;
    },


  },
  computed: {
    numQuotes() {
      if (this.startRangeIndex >= 0 && this.amount > 0) {
        const price = this.getPriceFromIndex(this.startRangeIndex);
        return price > 0 ? _.round(this.amount / price, 2) : 0;
      }
      return 0;
    },
    rateOfReturn() {
      return this.calculateRateOfReturn();
    },
    returns() {
     return formatter.format(this.amount * ( 1 + this.rateOfReturn / 100 ));
    },
    formattedAmount() {
      return formatter.format(this.amount);
    },
    fees() {
      return formatter.format(this.calculateFees());
    }
  }
};
</script>
