<template>
  <div class="w-100 bg-gradient border-bottom p-2 d-flex justify-content-between">
    <img src="../assets/logo.png" class="circle-image" alt="logo"/>
    <div class="d-flex align-items-baseline">
      <p ref="userName"></p>
      <div class="btn-group">
        <button class="btn" type="button">
          <img src="../assets/logo.png" class="circle-image" alt="profile"/>
        </button>
        <button type="button" class="btn btn-lg dropdown-toggle dropdown-toggle-split border-0"
                data-bs-toggle="dropdown" aria-expanded="false">
          <span class="visually-hidden">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu">
          <li>Profile</li>
          <li>
            <button @click="logout" class="logout">Logout</button>
          </li>
        </ul>
      </div>
    </div>

  </div>
  <authTest @name="username($event)"/>
  <posts/>
</template>

<script>

import authTest from './authTest.vue';
import posts from './APost.vue';
import {JWTAuth} from '../../services/jwt.js';

const jwtAuth = new JWTAuth('http://localhost:8000/auth/');

export default {
  name: 'App',
  components: {
    authTest,
    posts,
  },
  data() {
    return {
      imageSrc: '@/assets/logo.png',
      captions: {
        post1: 'Hi, This is my first sagi post!',
        post2: 'Hi, This is my second sagi post!',
      }
    }
  },
  methods: {
    async logout() {
      this.isLoggedIn = jwtAuth.logout();
      location.reload();
      console.log("loggedIn:" + this.isLoggedIn);
    },
    username(name) {
      this.$refs.userName.innerHTML = "<h4>Welcome " + name + "!</h4>";
    },

  },
}
</script>


<style scoped>

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

.dropdown-menu > li:hover,
.logout:hover {
  background-color: #525252;
}

.logout {
  color: white;
  border: none;
  background-color: inherit;
//transition: 0.2s;
}

.circle-image {
  clip-path: circle(50%);
  object-fit: cover;
  width: 50px;
  height: 50px;
}

.btn {
  padding: 0;
}
</style>