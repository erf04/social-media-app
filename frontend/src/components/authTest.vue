<template>
    <div id="app">
      <div v-if="isLoggedIn">
        <task-list></task-list>
        <button @click="logout">Logout</button>
        <p>hello {{ username }}</p>
      </div>
      <div v-else>
        <button @click="login">Login</button>
      </div>
      <div>
        <router-link  to="/signup"><button>signup</button></router-link> 
      </div>
    </div>
  </template>
  
  <script>
  // import axios from 'axios';
  import JWTAuth from '../../services/jwt.js';

  export default {
    data() {
      return {
        isLoggedIn: false,
        username:'',
      };
    },
    methods: {
      async login(){
        var jwtAuth=new JWTAuth('http://localhost:8000/auth/');
      
        this.isLoggedIn=await jwtAuth.login("test","test1234@");
        location.reload();
      
      console.log("loggedIn:"+this.isLoggedIn);
      },
      async logout(){
        var jwtAuth=new JWTAuth('http://localhost:8000/auth/');
        this.isLoggedIn=jwtAuth.logout();
        location.reload();
        console.log("loggedIn:"+this.isLoggedIn);
      }
      

    },
    async mounted() {
      var jwtAuth=new JWTAuth('http://localhost:8000/auth/');
      
      this.isLoggedIn=await jwtAuth.isAuthenticate();
      if (this.isLoggedIn===true){
        //go to the list
        let user=await jwtAuth.getCurrentUser();
        this.username=user.data.username;
      }
      else{
        //go to login page
      }

      console.log("loggedIn:"+this.isLoggedIn);
      

    },
  };
  </script>