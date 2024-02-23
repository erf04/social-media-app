<template>
  <div class="container mb-3">
    <div v-for="(post, index) in posts" :key="index" class="card" style="margin: 0 auto; height: auto; width: 25rem">
      <div class="p-2 pb-0 d-flex justify-content-between">
        <div class="d-flex" style="gap: 5px">
          <img src="../assets/logo.png" class="circle-image" alt="userProfile">
          <h5 style="font-weight: normal">{{post.author.username}}</h5>
        </div>
        <div>
          <button type="button" class="btn btn-lg border-0"
                  style="color: black"
                  data-bs-toggle="dropdown" aria-expanded="false">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6" style="width: 20px">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 12.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5ZM12 18.75a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5Z" />
            </svg>
          </button>
          <ul class="dropdown-menu">
            <li>
                Option 1
            </li>
            <li>
                Option 2
            </li>
          </ul>
        </div>
      </div>
      <hr />
      <img :src="getAbsoluteUrl(post.content)" class="card-img-top" alt="vue-logo">
      <hr />
      <div class="d-flex justify-content-between" style="padding: 0 1rem">
        <div class="d-flex w-25 justify-content-between">
          <button style="border: none; background-color: white" @click="liked">
            <svg xmlns="http://www.w3.org/2000/svg" :fill="likeFillColor" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 25px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z"/>
            </svg>
          </button>
          <a href="#" style="color: black">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 25px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.444 3 12c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483 0 0 1-.923 1.785A5.969 5.969 0 0 0 6 21c1.282 0 2.47-.402 3.445-1.087.81.22 1.668.337 2.555.337Z"/>
            </svg>
          </a>
          <a href="#" style="color: black">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="w-6 h-6" style="width: 25px">
              <path stroke-linecap="round" stroke-linejoin="round"
                    d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5"/>
            </svg>
          </a>
        </div>
        <button style="border: none; background-color: white" @click="saved">
          <svg xmlns="http://www.w3.org/2000/svg" :fill="saveFillColor" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6" style="width: 25px">
            <path stroke-linecap="round" stroke-linejoin="round" d="M17.593 3.322c1.1.128 1.907 1.077 1.907 2.185V21L12 17.25 4.5 21V5.507c0-1.108.806-2.057 1.907-2.185a48.507 48.507 0 0 1 11.186 0Z" />
          </svg>
        </button>
      </div>
      <hr />
      <div class="card-body">
        <h4>{{ post.title }}</h4>
        <div id="read-more">
          <div class="card-text">
            {{ post.description }}
            <div class="read-more-content">
              <p class="m-0">Additional content goes here</p>
            </div>
            <span v-if="post.description.length > 50" class="read-more-button" @click="toggleReadMore()">more...</span>
          </div>
        </div>
        <p class="card-text mt-2" style="color: gray; font-size: small; bottom: 0;">{{ post.created_at }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import {JWTAuth} from '../../services/jwt';

import TaskApi from '../../services/taskApi';

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
export default {
  // props: ['imageSrc', 'caption'],
  data() {
    return {
      longCaption: false,
      usernames: '',
      name: '',
      posts: [
        {
          title: "",
          description: "",
          content: "",
          author: {
            username: "",
            image: null,
          },
          created_at: "",
        }
      ],
      likeFillColor: 'none',
      saveFillColor: 'none',
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
    toggleReadMore() {
      const moreText = document.querySelector('.read-more-content');
      const buttonText = document.querySelector('.read-more-button');
      if (moreText.classList.contains('show')) {
        moreText.classList.remove('show');
        buttonText.innerHTML = 'more...';
      } else {
        moreText.classList.add('show');
        buttonText.innerHTML = 'less';
      }
    },
    async fetchTasks() {
      let taskApi=new TaskApi("http://localhost:8000/api/tasks","http://localhost:8000/auth");
      taskApi.getAuthorizedRequest()
      .then(api=>{
        return api.get('')
      })
        .then(response => {
            this.tasks = response.data;
            // console.log("TASKS:",this.tasks[1]);

          }).catch(error => {
        if (error.response.status === 401) {
          console.log("unauthorized");
          this.$router.push('/login');
        } else {
          console.log("unexpected error");
        }
      })
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
    saved() {
      if (this.saveFillColor === 'none') this.saveFillColor = 'black';
      else this.saveFillColor = 'none';
    },
    getPosts() {
      axios.get('http://localhost:8000/api/posts/all', {
        headers: {
          Authorization: `JWT ${localStorage.getItem("access_token")}`
        }
      })
          .then(response => {
            this.posts = response.data;
            console.log("response.data", response.data[0].author);
          })
          .catch(error => {
            console.log(error);
          });
    },
    getAbsoluteUrl(relativeUrl) {
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

hr {
  margin: 10px 0;
}

.card-body {
  padding-top: 0;
  padding-bottom: 7px;
  padding-left: 12px;
}

.circle-image {
  clip-path: circle(50%);
  object-fit: cover;
  width: 30px;
  height: 30px;
}

.btn {
  border: none;
  background-color: inherit;
}

li {
  margin: 0;
  width: 100%;
  transition: .3s;
}

.dropdown-menu {
  background-color: #686868;
  padding: 0;
}

.dropdown-menu > li {
  border-bottom: 1px solid #525252;
  color: white;
  padding: 10px 0 10px 10px;
  transition: 0.2s;
  border-radius: 5px;
}

.dropdown-menu > li:hover {
  background-color: #525252;
}

.read-more-content {
  display: none;
  opacity: 0;
  transition: opacity 0.5s ease;
}

.read-more-content.show {
  display: block;
  opacity: 1;
}

.read-more-button {
  cursor: pointer;
  color: gray;
  text-decoration: none;
}

</style>
