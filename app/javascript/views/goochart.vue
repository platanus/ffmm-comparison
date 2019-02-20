<template>
  <div id="app">
    <GooChart :real-asset-id="realAssetId" :name="name" />
  </div>
</template>

<script lang="ts">
import GooChart from '../components/GooChart.vue'
export default {
  name: 'app',
  components: {
    GooChart
  },
  props: {
    name: String,
    realAssetId: String,
  },
}
</script>
