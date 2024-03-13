<template>
  <div class="container emp-profile">
    <div class="row">
      <div class="col-md-4">
        <div class="profile-img justify-content-start">
          <img
              :src="getAbsoluteUrl(userInfo.image)"
              alt=""/>
          <div class="file btn btn-lg btn-primary">
            Change Photo
            <input type="file" name="file"/>
          </div>
        </div>
      </div>
      <div class="col-md-6">
        <div class="profile-head">
          <h5>
            {{ userInfo.username }}
          </h5>
          <h6>
            Web Developer and Designer
          </h6>
          <p class="proile-rating">RANKINGS : <span>8/10</span></p>
          <ul class="nav nav-tabs" style="margin-top: 60px;" id="myTab" role="tablist">
            <li class="nav-item">
              <button :class="showUserInfo ? `active` : ``" class="nav-link" @click="showUserInfo = true; showPosts = false;" id="home-tab">
                About
              </button>
            </li>
            <li class="nav-item">
              <button :class="showPosts ? `active` : ``" class="nav-link" @click="showPosts = true; showUserInfo = false" id="profile-tab">Posts</button>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-md-2">
        <input type="submit" class="profile-edit-btn" name="btnAddMore" value="Edit Profile"/>
        <button class="btn btn-primary mt-2" @click="GoToCreatePost">
          Create New Post
        </button>
      </div>
    </div>
    <profile-info v-if="showUserInfo"/>
    <profile-posts v-if="showPosts"/>
  </div>
  <footerMenu :fromProfile="true"/>
</template>

<script>
import router from "@/router";
import {JWTAuth} from '../../../services/jwt.js';
import footerMenu from '@/components/FooterMenu.vue';
import profileInfo from "./ProfileInfo.vue";
import profilePosts from "./ProfilePosts.vue"
import axios from "axios";

const baseURL = "http://localhost:8000/api";

const jwtAuth = new JWTAuth('http://localhost:8000/auth/');

export default {
  // mixins: [userInfo],
  components: {
    footerMenu,
    profileInfo,
    profilePosts,
  },
  data() {
    return {
      showUserInfo: false,
      showPosts: true,
      underline: "activeLink",
      userInfo: {
        email: '',
        userId: null,
        username: '',
        image: null,
      },
    }
  },
  methods: {
    GoToCreatePost() {
      router.push('profile/createPost');
    },
    async userData() {
      const user = await jwtAuth.getCurrentUser();
      axios.post(`${baseURL}/get-user/`, {
        username: user.username
      })
          .then(response => {
            this.userInfo = response.data;
          })
          .catch(err => {
            console.log(err);
          })
      this.userInfo = user;
      this.userInfo.userId = user.id;
      console.log(user);
    },
    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },

  },
  mounted() {
    this.userData();
  }
}
</script>

<style scoped>

.emp-profile {
  padding: 3%;
  margin-top: 1%;
  margin-bottom: 1%;
  border-radius: 0.5rem;
  background: #fff;
}

.profile-img {
  text-align: center;
}

.profile-img img {
  width: 70%;
  height: 100%;
}

.profile-img .file {
  position: relative;
  overflow: hidden;
  margin-top: -20%;
  width: 70%;
  border: none;
  border-radius: 0;
  font-size: 15px;
  background: #212529b8;
}

.profile-img .file input {
  position: absolute;
  opacity: 0;
  right: 0;
  top: 0;
}

.profile-head h5 {
  color: #333;
}

.profile-head h6 {
  color: #0062cc;
}

.profile-edit-btn {
  border: none;
  border-radius: 1.5rem;
  width: 70%;
  padding: 2%;
  font-weight: 600;
  color: #6c757d;
  cursor: pointer;
}

.proile-rating {
  font-size: 12px;
  color: #818182;
  margin-top: 5%;
}

.proile-rating span {
  color: #495057;
  font-size: 15px;
  font-weight: 600;
}

.profile-head .nav-tabs {
  margin-bottom: 5%;
}

.profile-head .nav-tabs .nav-link {
  font-weight: 600;
  border: none;
}

.profile-head .nav-tabs .nav-link.active {
  border: none;
  border-bottom: 2px solid #0062cc;
}

.profile-work {
  padding: 14%;
  margin-top: -15%;
}

.profile-work p {
  font-size: 12px;
  color: #818182;
  font-weight: 600;
  margin-top: 10%;
}

.profile-work a {
  text-decoration: none;
  color: #495057;
  font-weight: 600;
  font-size: 14px;
}

.profile-work ul {
  list-style: none;
}

.profile-tab label {
  font-weight: 600;
}

.profile-tab p {
  font-weight: 600;
  color: #0062cc;
}

.btn {
  border-radius: 50px;
  font-size: 16px;
}

.activeLink {
  text-decoration: underline;
}

</style>