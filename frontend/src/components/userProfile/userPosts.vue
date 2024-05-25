<template>
  <div v-if="posts.length !== 0">
  <div class="container d-flex flex-wrap justify-content-start" style="gap: 5px;">
      <div v-for="(post) in posts" :key="post.id" class="card"
           style="height: 250px; width: 18rem" @click="showPostList">
        <img :src="getAbsoluteUrl(post.content)" style="margin: auto 0; height: 100%; object-fit: cover" class="card-img-top" alt="vue-logo">
      </div>
    </div>
  </div>
  <div style="height: 500px" v-else>
    <h3 style="text-align: center">No Post Yet!</h3>
  </div>
</template>

<script>
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import {JWTAuth} from '../../../services/jwt';
import {mixins} from "@/mixins"
import router from "@/router";

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
const baseURL ="http://localhost:8000/api";
export default {
  mixins: [mixins],
  // props: ['imageSrc', 'caption'],
  data() {
    return {
      likeFillColor: [],
      saveFillColor: [],
      likeStatus: {
        like: false,
        dislike: true,
      },
      saveStatus: {
        save: false,
        unsave: true,
      },
      longCaption: false,
      usernames: '',
      name: '',
      posts: [
        {
          title: "",
          description: "",
          content: "",
          author: {
            username: "",
            image: null,
          },
          created_at: "",
        }
      ],
    }
  },
  mounted() {
    this.showUserPosts();
  },
  methods: {
    showPostList() {
      router.push('profile/postsView');
    },
    toggleReadMore() {
      const moreText = document.querySelector('.read-more-content');
      const buttonText = document.querySelector('.read-more-button');
      if (moreText.classList.contains('show')) {
        moreText.classList.remove('show');
        buttonText.innerHTML = 'more...';
      } else {
        moreText.classList.add('show');
        buttonText.innerHTML = 'less';
      }
    },

    GoToUserPage(name) {
      router.push('/' + name);
    },

    liked(index) {
      let elements = this.$refs.likeBounce;
      if (this.likeStatus.like === true) {
        elements[index].classList.remove("bounce-enter-active");
        elements[index].classList.remove("bounce-leave-active");
      } else if (this.likeStatus.dislike === true) {
        elements[index].classList.remove("bounceSagi-enter-active");
        elements[index].classList.remove("bounceSagi-leave-active");
      }
      if (this.likeFillColor[index] === 'none') this.likeFillColor[index] = 'red';
      else this.likeFillColor[index] = 'none';
      if (this.likeStatus.dislike === true) {
        elements[index].classList.add("bounce-enter-active");
        elements[index].classList.add("bounce-leave-active");
        this.likeStatus.like = true;
        this.likeStatus.dislike = false;
      } else if (this.likeStatus.like === true) {
        elements[index].classList.add("bounceSagi-enter-active");
        elements[index].classList.add("bounceSagi-leave-active");
        this.likeStatus.dislike = true;
        this.likeStatus.like = false;
      }
    },
    saved(index) {
      let elements = this.$refs.savedBounce;
      if (this.saveStatus.save === true) {
        elements[index].classList.remove("bounce-enter-active");
        elements[index].classList.remove("bounce-leave-active");
      } else if (this.saveStatus.unsave === true) {
        elements[index].classList.remove("bounceSagi-enter-active");
        elements[index].classList.remove("bounceSagi-leave-active");
      }
      if (this.saveFillColor[index] === 'none') this.saveFillColor[index] = 'black';
      else this.saveFillColor[index] = 'none';

      if (this.saveStatus.unsave === true) {
        elements[index].classList.add("bounce-enter-active");
        elements[index].classList.add("bounce-leave-active");
        this.saveStatus.save = true;
        this.saveStatus.unsave = false;
      } else if (this.saveStatus.save === true) {
        elements[index].classList.add("bounceSagi-enter-active");
        elements[index].classList.add("bounceSagi-leave-active");
        this.saveStatus.unsave = true;
        this.saveStatus.save = false;
      }
    },

    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },

    async showUserPosts() {
      axios.get(`${baseURL}/posts`,{
        headers:{
          Authorization:`JWT ${await jwtAuth.getAccessToken()}`
        }
      })
          .then(response => {
            this.posts = response.data;
            console.log(response.data);
          })
          .catch(err => {
            console.log(err);
          })
    }

  },
}
</script>

<style scoped>

button {
  margin: 0;
  padding: 0;
}

h3 {
  margin: 40px 0 0;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

hr {
  margin: 10px 0;
}

.card-body {
  padding-top: 0;
  padding-bottom: 7px;
  padding-left: 12px;
}

.circle-image {
  clip-path: circle(50%);
  object-fit: cover;
  width: 30px;
  height: 30px;
}

.btn {
  border: none;
  background-color: inherit;
}

li {
  margin: 0;
  width: 100%;
  transition: .3s;
}

.dropdown-menu {
  background-color: #686868;
  padding: 0;
}

.dropdown-menu > li {
  border-bottom: 1px solid #525252;
  color: white;
  padding: 10px 0 10px 10px;
  transition: 0.2s;
  border-radius: 5px;
}

.dropdown-menu > li:hover {
  background-color: #525252;
}

.read-more-content {
  display: none;
  opacity: 0;
  transition: opacity 0.5s ease;
}

.read-more-content.show {
  display: block;
  opacity: 1;
}

.read-more-button {
  cursor: pointer;
  color: gray;
  text-decoration: none;
}

.bounce-enter-active {
  animation: bounce-in 0.3s ease-in-out;
}

.bounce-leave-active {
  animation: bounce-in 0.3s reverse ease-in-out;
}

@keyframes bounce-in {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.5);
  }
  100% {
    transform: scale(1);
  }
}

.bounceSagi-enter-active {
  animation: bounce-in-sagi 0.3s ease-in-out;
}

.bounceSagi-leave-active {
  animation: bounce-in-sagi 0.3s reverse ease-in-out;
}

@keyframes bounce-in-sagi {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(0);
  }
  100% {
    transform: scale(1);
  }
}

</style>
