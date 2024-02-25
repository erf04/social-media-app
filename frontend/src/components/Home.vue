<template>
  <div class="w-100 border-bottom mb-0 pb-0 p-2 d-flex justify-content-between" style="background-color: #29292e">
    <img src="../assets/logo1.png" style="width: 250px; height: 60px" alt="logo"/>
    <div class="d-flex align-items-center">
      <p style="color: white" ref="userName"></p>
      <div class="btn-group">
        <button @click="GoToProfile" class="border-0" style="background-color: inherit">
          <img src="../assets/logo.png" class="circle-image" alt="profile"/>
        </button>
        <button type="button" class="btn btn-lg dropdown-toggle dropdown-toggle-split border-0"
                data-bs-toggle="dropdown" aria-expanded="false">
          <span class="visually-hidden">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu">
          <li>
            <button @click="GoToProfile" class="btn">
              Profile
            </button>
          </li>
          <li>
            <button @click="logout" class="btn">Logout</button>
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
import router from "@/router";
import {JWTAuth} from '../../services/jwt.js';

const jwtAuth = new JWTAuth('http://localhost:8000/auth/');

// history.pushState(null, null, location.href);
// window.onpopstate = function () {
//   history.go(1);
// };

// history.pushState(null, null, document.URL);
// window.addEventListener('popstate', function () {
//   history.pushState(null, null, document.URL);
// });

export default {
  name: 'App',
  components: {
    authTest,
    posts,
  },
  data() {
    return {
      userName: '',
    }
  },
  methods: {
    async logout() {
      this.isLoggedIn = jwtAuth.logout();
      location.reload();
      console.log("loggedIn:" + this.isLoggedIn);
    },
    username(name) {
      this.userName = name;
      this.$refs.userName.innerHTML = "<h4>Welcome " + name + "!</h4>";
    },
    GoToProfile() {
      router.push('/profile/' + this.userName)
    }
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

.dropdown-menu > li:hover {
  background-color: #525252;
}

.circle-image {
  clip-path: circle(50%);
  object-fit: cover;
  width: 50px;
  height: 50px;
}

.btn {
  padding: 0;
  color: white;
}

p {
  margin: 0;
}

</style>