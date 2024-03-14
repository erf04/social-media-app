<template>
  <div class="container">
    <div class="input-group mb-3 w-75 mx-auto mt-5">
      <input @keyup.enter="filteredUsers" v-model="searchValue" type="text" placeholder="Search" class="form-control"
             aria-label="Default" aria-describedby="inputGroup-sizing-default">
      <button @click="filteredUsers" class="input-group-text" id="inputGroup-sizing-default">
        <svg style="width: 20px; height: 20px" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
        </svg>
      </button>
    </div>
    <div class="w-75 mx-auto">
      <div v-for="user in resultUsers" :key="user.pk">
        <div class="results mx-auto">
          <div class="d-flex align-items-center" style="gap: 10px">
            <img style="width: 30px; height: 30px; border-radius: 50%" :src="getAbsoluteUrl(user.image)" alt="">
            <div>
              <h6 class="m-0">{{ user.username }}</h6>
              <p class="m-0" style="font-size: small">n Followers</p>
            </div>
          </div>
          <button class="followBtn" @mouseleave="sagi2($event)" @mouseenter="sagi($event)" @click="followToggle($event)">Follow</button>
        </div>
        <hr/>
      </div>
    </div>
  </div>
</template>

<script>
import {JWTAuth} from "../../services/jwt";
import axios from "axios";

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
const baseURL = "http://localhost:8000/api";

export default {
  data() {
    return {
      users: [],
      searchValue: '',
      resultUsers: [],
    }
  },
  methods: {
    async getAllUsers() {
      await axios.get(`${baseURL}/users/all/`, {
        headers: {
          Authorization: `JWT ${await jwtAuth.getAccessToken()}`
        },
      })
          .then(response => {
            this.users = response.data;
          })
          .catch(error => {
            console.log(error);
          })
    },
    async filteredUsers() {
      await axios.post(`${baseURL}/users/filter/`, {
            key: this.searchValue,
          },
          {
            headers: {
              Authorization: `JWT ${await jwtAuth.getAccessToken()}`
            }
          })
          .then(response => {
            console.log(response.data);
            this.resultUsers = response.data;
          })
          .catch(error => {
            console.log(error);
          })
    },
    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },
    followToggle(element) {
      if (element.target.innerText === "Follow") {
        element.target.innerText = "Following"
        element.target.style.backgroundColor = "inherit";
        element.target.style.color = "#53ee9f";
      } else {
        element.target.innerText = "Follow"
        element.target.style.backgroundColor = "#53ee9f";
      }
    },
    sagi(element) {
      if (element.target.innerText === 'Following') {
        element.target.innerText = "UnFollow";
        element.target.style.backgroundColor = "red";
        element.target.style.color = "black";
      } else {
        element.target.innerText = "Follow"
        element.target.style.backgroundColor = "#53ee9f";
      }
    },
    sagi2(element) {
      if (element.target.innerText === 'UnFollow') {
        element.target.innerText = "Following"
        element.target.style.backgroundColor = "inherit";
        element.target.style.color = "#53ee9f";
      } else if (element.target.innerText === "Following") {
        element.target.innerText = "Following";
        element.target.style.backgroundColor = "inherit";
        element.target.style.color = "#53ee9f";
      } else if (element.target.innerText === "Follow") {
        element.target.innerText = "Follow";
        element.target.style.backgroundColor = "#53ee9f";
      }
    }
  },
  mounted() {
    this.getAllUsers();
  }
}
</script>

<style>
.results {
  display: flex;
  gap: 10px;
  justify-content: space-between;
}

.followBtn {
  background-color: #53ee9f;
  border-radius: 5px;
  transition: 0.2s;
}

.followBtn:hover {
  background-color: #08cc81;
}

</style>