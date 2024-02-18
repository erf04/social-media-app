<template>
  
  <div style="text-align: center; margin-top: 5rem" class="container w-25">
    <h2>login</h2><br>
    <form >
  <!-- Email input -->
  <div class="form-outline mb-4">
    <label class="form-label" for="form2Example1">username</label>

    <input type="email" id="form2Example1" class="form-control" v-model="username" />
  </div>

  <!-- Password input -->
  <div class="form-outline mb-4">
    <label class="form-label" for="form2Example2">Password</label>
    <input type="password" id="form2Example2" class="form-control"  v-model="password"/>
  </div>

  <!-- 2 column grid layout for inline styling -->
  <div class="row mb-4">
    <div class="col d-flex justify-content-center">
      <!-- Checkbox -->
      <div class="form-check">
        <input class="form-check-input" type="checkbox" value="" id="form2Example31" checked />
        <label class="form-check-label" for="form2Example31"> Remember me </label>
      </div>
    </div>

    <div class="col">
      <!-- Simple link -->
      <a href="#!">Forgot password?</a>
    </div>
  </div>

  <!-- Submit button -->
  <button type="button" class="btn btn-primary btn-block mb-4" @click="submit">login</button>

  <!-- Register buttons -->
  <div class="text-center">
    <p>Not a member? <router-link to="/signup">Register</router-link></p>
    <p>or sign up with:</p>
    <button type="button" class="btn btn-link btn-floating mx-1">
      <i class="fab fa-facebook-f"></i>
    </button>

    <button type="button" class="btn btn-link btn-floating mx-1">
      <i class="fab fa-google"></i>
    </button>

    <button type="button" class="btn btn-link btn-floating mx-1">
      <i class="fab fa-twitter"></i>
    </button>

    <button type="button" class="btn btn-link btn-floating mx-1">
      <i class="fab fa-github"></i>
    </button>
  </div>
</form>
  </div>
</template>

<script>
  import {JWTAuth,messages} from '../../services/jwt.js';
  import router from "@/router";

  const jwtAuth=new JWTAuth('http://localhost:8000/auth/');

  export default{
    data(){
      return  {
        username:'',
        password:'',
        isLoggedIn:Boolean,

      };
    },

    methods:{
      async submit(){


        this.isLoggedIn=await jwtAuth.login(this.username.trim(),this.password.trim());
        
        console.log(this.isLoggedIn);
        if (this.isLoggedIn==true){
          router.push('/');
          
        }
        else{
          console.log(messages);
        }
      },
      

    },
    mounted(){

    }
  }
</script>