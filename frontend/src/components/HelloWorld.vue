<template>
  <div class="hello">
    <ul v-for="task in messages" :key="task">
      <li>{{task}}</li>
    </ul>
<!--    <button @click="showMessage">click to say hello world</button>-->
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      messages: [],
    }
  },
  mounted() {
    // this.fetchTasks();
    // this.fetchTasks();
    this.fetchTask(1);
    this.fetchTask(2);
    },
  methods: {
    // fetchTasks() {
    //   axios.get('http://localhost:8000/api/fetchall/')
    //       .then(response => {
    //         this.tasks = response.data;
    //         // this.message=response.data.message;
    //         // console.log(response);
    //         // console.log('tasks: ', this.tasks[0].description);
    //       })
    //       .catch(error => {
    //         console.error('Error fetching tasks:', error);
    //       });
    // },

    fetchTask(id){
      axios.get('http://localhost:8000/api/fetch/'+id+'/')
          .then(response => {
            // this.tasks = response.data;
            this.messages[id-1] = response.data.description;
            // console.log(response.data);
            // console.log('response: ', this.messages);
          })
          .catch(error => {
            console.error('Error fetching tasks:', error);
          });
    },
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
