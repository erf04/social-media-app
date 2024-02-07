<template>
    <div id="app">
      <div v-if="isLoggedIn">
        <task-list></task-list>
        <button @click="logout">Logout</button>
      </div>
      <div v-else>
        <button @click="login">Login</button>
      </div>
    </div>
  </template>
  
  <script>
  import api from '../../services/api.js'; 
  export default {
    data() {
      return {
        isLoggedIn: false,
      };
    },
    methods: {
      async login() {
        // try {
        //   const response = await api.post('jwt/create', {
        //     username: 'test',
        //     password: 'test1234@',
        //   });
  
        //   // Save access token in localStorage
        //   localStorage.setItem('access_token', response.data.access);
  
        //   // Update component state
        //   this.isLoggedIn = true;
        // } catch (error) {
        //   console.error('Error logging in:', error);
        // }
        let user={
          username:"test",
          password:"test1234@"
        }
        api.post("jwt/create",user)
        .then(response=>{
          console.log(response);
          localStorage.setItem("access_token",response.data.access);
          localStorage.setItem("refresh_token",response.data.refresh);
        })
        .catch(error=>{
          console.log(error);
        })
      },
      logout() {
        // Clear access token from localStorage
        localStorage.removeItem('access_token');
  
        // Update component state
        this.isLoggedIn = false;
      },
    },
    mounted() {
      // Check if there is a token in localStorage
      const accessToken = localStorage.getItem('access_token');
      if (accessToken) {
        this.isLoggedIn = true;
      }
    },
  };
  </script>