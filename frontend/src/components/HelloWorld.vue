<template>
  <div class="hello">
    <h1>{{message}}</h1>
    <button @click="fetchTasks">click to say hello world</button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      message:'',
    }
  },
  mounted() {
    // this.fetchTasks();
    this.fetchTasks();
    this.fetchTask(1);
    },
  methods: {
    fetchTasks() {
      axios.get('http://localhost:8000/api/fetchall/')
          .then(response => {
            // this.tasks = response.data;
            // this.message=response.data.message;
            console.log(response);
          })
          .catch(error => {
            console.error('Error fetching tasks:', error);
          });
    },

    fetchTask(id){
      axios.get('http://localhost:8000/api/fetch/'+id+'/')
          .then(response => {
            // this.tasks = response.data;
            // this.message=response.data.message;
            console.log(response);
          })
          .catch(error => {
            console.error('Error fetching tasks:', error);
          });
    }
  }

}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
