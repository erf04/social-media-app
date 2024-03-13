<template>
  <!-- The Modal -->
  <div ref="myModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <span @click="closeModal" class="close">&times;</span>
      <p ref="showMessage"></p>
    </div>
  </div>

  <div style="text-align: center; margin-top: 5rem" class="container w-25">
    <h2>signup</h2><br>
    <form>
      <div class="form-outline mb-4">
        <label class="form-label" for="form2Example1">username</label>
        <input @keyup.enter="submit" type="email" id="form2Example1" class="form-control" v-model="username"/>
      </div>

      <div class="form-outline mb-4">
        <label class="form-label" for="form2Example2">Password</label>
        <input @keyup.enter="submit" type="password" id="form2Example2" class="form-control" v-model="password"/>
      </div>

      <div class="form-outline mb-4">
        <label class="form-label" for="form2Example3">Email</label>
        <input @keyup.enter="submit" type="email" id="form2Example3" class="form-control" v-model="email"/>
      </div>

      <div class="row mb-4">
        <div class="col d-flex justify-content-center">
          <!-- Checkbox -->
<!--          <div class="form-check">-->
<!--            <input class="form-check-input" type="checkbox" value="" id="form2Example31" checked/>-->
<!--            <label class="form-check-label" for="form2Example31"> Remember me </label>-->
<!--          </div>-->
        </div>
      </div>

      <!-- Submit button -->
      <button type="button" class="btn btn-primary btn-block mb-4" @keyup.enter="submit" @click="submit">register</button>

      <!-- Register buttons -->
      <div class="text-center">

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
import {JWTAuth, messages} from '../../services/jwt.js';
import router from "@/router";


const jwtAuth = new JWTAuth('http://localhost:8000/auth/');
// console.log(messages);
export default {
  data() {
    return {
      username: '',
      password: '',
      email: '',
      isLoggedIn: Boolean,
      messages: messages,
    };
  },

  methods: {
    async submit() {
      this.isLoggedIn = await jwtAuth.signup(this.username.trim(), this.password.trim(), this.email.trim());
      // jwtAuth.signup(this.username.trim(),this.password.trim(),this.email.trim())
      // .then(()=>{
      //   this.isLoggedIn=true;
      //   router.push('/');

      // }).catch(error=>{
      //   alert(error);
      //   this.isLoggedIn=false;

      // })

      console.log(this.isLoggedIn);
      if (this.isLoggedIn === true) {
        await router.push('/');
      } else {
        const modal = this.$refs.myModal;
        modal.style.display = "block";
        const text = this.$refs.showMessage;
        for (const textElement of messages) {
          const type = Object.keys(textElement);
          var result = '';
          for (const string of type) {
            console.log(`string :${string}`);

            if (string === 'email') result += textElement.email;
            if (string === 'password')
              result += textElement.password;
            if (string === 'username')
              result += textElement.username;
            result+="<br/>"

          }
          // console.log("result:"+result);
          text.innerHTML = result;
        }
        // console.log("MESSAGES:", messages)
        // console.log("MESSAGES:", messages[0]);
        // console.log(messages);
      }
    },
    closeModal() {
      const modal = this.$refs.myModal;
      modal.style.display = 'none';
    }
  },
  mounted() {

  }
}
</script>

<style>
/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0, 0, 0); /* Fallback color */
  background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto; /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button */
.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}
</style>