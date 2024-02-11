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

  const jwtAuth=new JWTAuth('http://localhost:8000/auth/');
  export default {
    data() {
      return {
        isLoggedIn: false,
        username:'',
      };
    },
    methods: {
      async login(){
        
      
        this.isLoggedIn=await jwtAuth.login("erfan",'erfank');
        location.reload();
      
      console.log("loggedIn:"+this.isLoggedIn);
      },
      async logout(){
        
        this.isLoggedIn=jwtAuth.logout();
        location.reload();
        console.log("loggedIn:"+this.isLoggedIn);
      }
      

    },
    async mounted() {
  
      
      this.isLoggedIn=await jwtAuth.isAuthenticate();
      if (this.isLoggedIn===true){
        //go to the list
        let user=await jwtAuth.getCurrentUser();
        if (user==null){
          // need to login again
        }
        else{
          this.username=user.data.username;
        }
        
      }
      else{
        //go to login page
      }

      console.log("loggedIn:"+this.isLoggedIn);
      

    },
  };
  </script>