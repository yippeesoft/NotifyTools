<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
  import Component from 'vue-class-component'

  @Component
  export default class app extends Vue {
    // data properties
    something:boolean = false

    // normal lifecycle hooks
    mounted () {
      console.log(this.something)
    }

    // methods
    k (n: number) : number {
      return 0
    }

    // computed properties
    get thing ():string {
      return 'hey'
    }
  }

</script>

<style>
  /* CSS */
</style>
