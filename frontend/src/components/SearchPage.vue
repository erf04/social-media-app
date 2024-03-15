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
      <div v-for="user in users" :key="user.pk">
        <div class="results mx-auto">
          <div class="d-flex align-items-center" style="gap: 10px">
            <img style="width: 30px; height: 30px; border-radius: 50%" :src="getAbsoluteUrl(user.image)" alt="">
            <div>
              <h6 class="m-0">{{ user.username }}</h6>
              <p class="m-0" style="font-size: small">{{user.followers_count}} Followers</p>
            </div>
          </div>
          <button v-text="user.is_following ? 'Following' : 'Follow'" ref="followBtn" class="followBtn" @mouseleave="leave($event.target)" @mouseenter="hover($event.target)" @click="followToggle($event.target)"></button>
        </div>
        <hr/>
      </div>
    </div>
  </div>
  
  <footerMenu/>
</template>

<script>
import {JWTAuth} from "../../services/jwt";
import axios from "axios";
import footerMenu from '@/components/FooterMenu.vue';

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
const baseURL = "http://localhost:8000/api";

export default {
  components: {
    footerMenu,
  },
  data() {
    return {
      users: [],
      searchValue: '',
      resultUsers: [],
      followStatus: '',
    }
  },
  methods: {
    async getAllUsers() {
      axios.get(`${baseURL}/users/all/`, {
        headers: {
          Authorization: `JWT ${await jwtAuth.getAccessToken()}`
        },
      })
          .then(response => {
            // console.log(response.data);
            this.users = response.data;
          })
          .catch(error => {
            console.log(error);
          })
    },
    async filteredUsers() {
      axios.post(`${baseURL}/users/filter/`, {
            key: this.searchValue,
          },
          {
            headers: {
              Authorization: `JWT ${await jwtAuth.getAccessToken()}`
            }
          })
          .then(response => {
            console.log("Filtered users", response.data);
            this.resultUsers = response.data;
            // console.log(response.data);
            this.users = response.data;
          })
          .catch(error => {
            console.log(error);
          })
    },
    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },
    followToggle(element) {
      if (element.innerText === "Follow") {
        element.innerText = "Following"
        element.style.backgroundColor = "inherit";
        element.style.color = "#53ee9f";
      } else {
        element.innerText = "Follow"
        element.style.backgroundColor = "#53ee9f";
        element.style.color = "black";
      }
    },
    hover(element) {
      if (element.innerText === 'Following') {
        element.innerText = "UnFollow";
        element.style.backgroundColor = "red";
        element.style.color = "black";
      } else {
        element.innerText = "Follow"
        element.style.backgroundColor = "#53ee9f";
      }
    },
    leave(element) {
      if (element.innerText === 'UnFollow') {
        element.innerText = "Following"
        element.style.backgroundColor = "inherit";
        element.style.color = "#53ee9f";
      } else if (element.innerText === "Following") {
        element.innerText = "Following";
        element.style.backgroundColor = "inherit";
        element.style.color = "#53ee9f";
      } else if (element.innerText === "Follow") {
        element.innerText = "Follow";
        element.style.backgroundColor = "#53ee9f";
      }
    },
    async follow(followingId){
      let body={
        "following_id":followingId
      }
      axios.post(`${baseURL}/follower/add/`,body,{
        headers:{
          Authorization:`JWT ${await jwtAuth.getAccessToken()}`
        }
      })
      .then(res=>{
        console.log(res);
      })
      .catch(err=>{
        console.log(err);
      })
    }
  },
  watch:{
    searchValue:function (){
      this.filteredUsers();
    }
  },
  mounted() {
    this.getAllUsers();
  },
  updated() {
    for(let element of this.$refs.followBtn) {
      if (element.innerHTML === "Following") {
        element.innerText = "Following"
        element.style.backgroundColor = "inherit";
        element.style.color = "#53ee9f";
      }
    }
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