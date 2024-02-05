<template>
  <div class="container">
  <table class="table table-striped">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">title</th>
        <th scope="col">description</th>
        <th scope="col">completed</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(task,index) in tasks" :key="task.id">
        <th scope="row">{{++index}}</th>
        <td>{{ task.title }}</td>
        <td>{{task.description}}</td>
        <td><input type="checkbox" name="" id="" checked="{{task.completed}}"></td>
      </tr>
      
    </tbody>
  </table>
  </div>
</template>

<script>
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
export default {
  data() {
    return {
      tasks: [],
    }
  },
  mounted() {
    this.fetchTasks();
    },
  methods: {
    fetchTasks() {
      axios.get('http://localhost:8000/api/fetchall/')
          .then(response => {
            this.tasks = response.data;
            
          })
          .catch(error => {
            console.error('Error fetching tasks:', error);
          });
    },

    fetchTask(id){
      axios.get('http://localhost:8000/api/fetch/'+id+'/')
          .then(response => {
            console.log(response);
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
