<template>
<!--  <img alt="Vue logo" src="./assets/logo.png">-->
  <!-- <HelloWorld />
  <TaskForm/> -->
  <authTest/>
  <HelloWorld/>
</template>

<script>

import authTest from './components/authTest.vue';
import HelloWorld from './components/HelloWorld.vue';

export default {
  // name: 'App',
  components: {
    authTest,
    HelloWorld
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
