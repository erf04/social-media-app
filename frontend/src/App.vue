<template>
<!--  <img alt="Vue logo" src="./assets/logo.png">-->
  <HelloWorld />
  <TaskForm/>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue';
import TaskForm from './components/TaskForm.vue';

export default {
  // name: 'App',
  components: {
    HelloWorld,
    TaskForm
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
