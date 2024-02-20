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
        <th scope="row">{{ ++index }}</th>
        <td>{{ task.title }}</td>
        <td>{{ task.description }}</td>
        <td><input type="checkbox" name="" id="" :checked="task.completed"></td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import {JWTAuth} from '../../services/jwt';

import taskApi from '../../services/taskApi';

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
export default {
  data() {
    return {
      tasks: [],
    }
  },
  async mounted() {
    // location.reload();
    let taskAuth = await jwtAuth.isAuthenticate();
    console.log(`task auth:${taskAuth}`);
    if (taskAuth)
      await this.fetchTasks();
  },
  methods: {
    async fetchTasks() {
      taskApi.get('', {
        headers: {Authorization: `JWT ${await jwtAuth.getAccessToken()}`}
      })
          .then(response => {
            this.tasks = response.data;
            console.log("TASKS:",this.tasks[1]);

          }).catch(error => {
        if (error.response.status === 401) {
          console.log("unauthorized");
        } else {
          console.log("unexpected error");
        }
      })


    },

    fetchTask(id) {
      taskApi.get(id + '/')
          .then(response => {
            console.log(response);
          })
          .catch(error => {
            console.error('Error fetching tasks:', error);
          });
    },

    getUsers() {
      axios.get("https://localhost:8000/auth/users/")
          .then((response) => {
            console.log(response);
          })
          .catch(error => {
            console.log(error);
          })
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
