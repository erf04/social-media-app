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
    <h2>login</h2><br>
    <form>
      <!-- Email input -->
      <div class="form-outline mb-4">
        <label class="form-label" for="form2Example1">username</label>

        <input type="email" id="form2Example1" class="form-control" v-model="username"/>
      </div>

      <!-- Password input -->
      <div class="form-outline mb-4">
        <label class="form-label" for="form2Example2">Password</label>
        <input type="password" id="form2Example2" class="form-control" v-model="password"/>
      </div>

      <!-- 2 column grid layout for inline styling -->
      <div class="row mb-4">
<!--        <div class="col d-flex justify-content-center">-->
          <!-- Checkbox -->
<!--          <div class="form-check">-->
<!--            <input class="form-check-input" type="checkbox" value="" id="form2Example31" checked/>-->
<!--            <label class="form-check-label" for="form2Example31"> Remember me </label>-->
<!--          </div>-->
<!--        </div>-->

        <div class="col">
          <!-- Simple link -->
          <a href="#!">Forgot password?</a>
        </div>
      </div>

      <!-- Submit button -->
      <button type="button" class="btn btn-primary btn-block mb-4" @click="submit">login</button>

      <!-- Register buttons -->
      <div class="text-center">
        <p>Not a member?
          <router-link to="/signup">Register</router-link>
        </p>
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
import {isMemoSame} from "vue";

const jwtAuth = new JWTAuth('http://localhost:8000/auth/');

// When the user clicks anywhere outside of the modal, close it
// window.onclick = function (event) {
//   if (event.target === modal) {
//     modal.style.display = "none";
//   }
// }

export default {
  data() {
    return {
      username: '',
      password: '',
      isLoggedIn: Boolean,
      messages: messages,
    };
  },

  methods: {
    isMemoSame,
    async submit() {
      this.isLoggedIn = await jwtAuth.login(this.username.trim(), this.password.trim());
      console.log(this.isLoggedIn);
      if (this.isLoggedIn === true) {
        await router.push('/');
      } else {
        const modal = this.$refs.myModal;
        modal.style.display = "block";
        const text = this.$refs.showMessage;
        for (const textElement of messages) {
          text.innerHTML = textElement.detail;
        }
        console.log("MESSAGES:", messages);
      }
    },
    closeModal() {
      const modal = this.$refs.myModal;
      modal.style.display = 'none';
    }
  },
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