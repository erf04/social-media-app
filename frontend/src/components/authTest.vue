<template>
  <div id="app">
    <div class="container d-flex mt-5 justify-content-center">
      <div style="text-align: center">
        <div v-if="isLoggedIn">
          <!--<task-list></task-list>-->
<!--          <button @click="logout">Logout</button>-->
<!--          <p>hello {{ username }}</p>-->
        </div>
        <div v-else>
          <button @click="login">Login</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import axios from 'axios';
import {JWTAuth, messages} from '../../services/jwt.js';
import router from "@/router";
// import { useRouter } from 'vue-router'

const jwtAuth = new JWTAuth('http://localhost:8000/auth/');
console.log(messages);
export default {
  data() {
    return {
      isLoggedIn: false,
      username: '',
    };
  },
  methods: {
    async login() {
      this.isLoggedIn = await jwtAuth.login("erfan", 'erfank');
      // location.reload();
      console.log("loggedIn:" + this.isLoggedIn);

    },
    // async logout() {
    //   this.isLoggedIn = jwtAuth.logout();
    //   location.reload();
    //   console.log("loggedIn:" + this.isLoggedIn);
    // },
  },
  async mounted() {
    this.isLoggedIn = await jwtAuth.isAuthenticate();
    if (this.isLoggedIn === true) {
      //go to the list
      let user = await jwtAuth.getCurrentUser();
      if (user == null) {
        // need to login again
        await router.push('/login');
      } else {
        this.username = user.username;
        await router.push('/');
      }
    } else {
      // await router.push('/login');
      //go to login page
      await router.push('/login');
    }
    // console.log("loggedIn:" + this.isLoggedIn);
    this.$emit('name', this.username);
  },
  // sendName() {
  // }
};
</script>