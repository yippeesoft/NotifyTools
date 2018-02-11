<template>
    <div>
        <input v-model="msg">
        <p>prop: {{propMessage}}</p>
        <p>msg: {{msg}}</p>
        <p>helloMsg: {{helloMsg}}</p>
        <p>computed msg: {{computedMsg}}</p>
        <button @click="greet">Greet</button>
    </div>
</template>

<script lang="ts">
    import Vue from 'vue'
    import Component from 'vue-class-component'

    @Component
    export default class sf extends Vue {
        // initial data
        msg = 123
        propMessage= 456
        // use prop values for initial data
        helloMsg = 'Hello, ' + this.propMessage

        // lifecycle hook
        mounted () {
            this.greet()
        }

        // computed
        get computedMsg () {
            return 'computed ' + this.msg
        }

        // method
        greet () {
            alert('greeting: ' + this.msg)
        }
    }
</script>