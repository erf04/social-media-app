<template>
  <div class="container mt-3">
    <div class="card" style="width: 18rem; margin: 0 auto">
      <img :src="getAbsoluteUrl(postImage)" class="card-img-top" alt="vue-logo">
      <h5>{{title}}</h5>
      <div class="card-body">
        <div class="d-flex w-25 justify-content-between">
          <button style="border: none; background-color: white" @click="liked()">
            <svg xmlns="http://www.w3.org/2000/svg" :fill="likeFillColor" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 20px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z"/>
            </svg>
          </button>
          <a href="#" style="color: black">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 20px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.444 3 12c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483 0 0 1-.923 1.785A5.969 5.969 0 0 0 6 21c1.282 0 2.47-.402 3.445-1.087.81.22 1.668.337 2.555.337Z"/>
            </svg>
          </a>
          <a href="#" style="color: black">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 20px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5"/>
            </svg>
          </a>
        </div>
        <p class="card-text">{{caption}}</p>
        <p class="card-text">{{authorName}}</p>
      </div>
    </div>
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
  // props: ['imageSrc', 'caption'],
  data() {
    return {
      tasks: [],
      likeFillColor: 'none',
      title: '',
      caption: '',
      authorName: '',
      postImage: '',
    }
  },
  async mounted() {
    // location.reload();
    let taskAuth = await jwtAuth.isAuthenticate();
    // console.log(`task auth:${taskAuth}`);
    if (taskAuth) await this.fetchTasks();
    this.getPosts();
    // this.$emit('nam)
  },
  methods: {
    async fetchTasks() {
      taskApi.get('', {
        headers: {Authorization: `JWT ${await jwtAuth.getAccessToken()}`}
      })
          .then(response => {
            this.tasks = response.data;
            // console.log("TASKS:",this.tasks[1]);

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
    },

    liked() {
      if (this.likeFillColor === 'none') this.likeFillColor = 'red';
      else this.likeFillColor = 'none';
    },
    getPosts() {
      axios.get('http://localhost:8000/api/posts/all', {
        headers: {
          Authorization: `JWT ${localStorage.getItem("access_token")}`
        }
      })
          .then(response => {
            this.title = response.data[0].title;
            this.caption = response.data[0].description;
            this.authorName = response.data[0].author.username;
            this.postImage = response.data[0].content;
            console.log(this.postImage);
          })
          .catch(error => {
            console.log(error);
          });
    },
    getAbsoluteUrl(relativeUrl){
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    }

  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

button {
  margin: 0;
  padding: 0;
}

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
