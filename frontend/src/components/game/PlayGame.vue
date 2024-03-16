<template>
  <div class="container mt-5">
    <div style="text-align: center">
      <h1>Welcome to GAMES!</h1>
      <h3>Have Fun! :)</h3>
    </div>
    <div class="centerBox flex-wrap justify-content-start" style="gap: 50px">
      <div v-for="game in games" :key="game.id" :style="`background-image: ${getAbsoluteUrl(game.image)}`" class="categoryWrapper">
        <h1>{{ game.name }}</h1>
        <button @click="goToGame(game.route)">
          <span>
            <span>
              <span data-attr-span="Play!">
                Play!
              </span>
            </span>
          </span>
        </button>
      </div>
    </div>
  </div>
  <footer-menu/>
</template>

<script>
import router from "@/router";
import footerMenu from "@/components/FooterMenu.vue";
import axios from "axios";
import { JWTAuth } from "../../../services/jwt";
const baseURL="http://localhost:8000/game";

const jwtAuth = new JWTAuth("http://localhost:8000/auth");


export default {
  components: {
    footerMenu,
  },
  data() {
    return {
      games: [{}]
    }
  },
  methods: {
    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },
    goToGame(game) {
      router.push('game/'+game);
    },
    async getGames(){
      axios.get(`${baseURL}/list/`,{
        headers:{
          Authorization:`JWT ${await jwtAuth.getAccessToken()}`
        }
      })
      .then(res=>{
        console.log(res);
        this.games=res.data;
      })
      .catch(err=>{
        console.log(err);
      })
    },

  },
  async mounted(){
    await this.getGames();
  }
}
</script>

<style scoped>

.centerBox{
  display: flex;
  justify-content: center;
  align-items: center;
  height: auto;
  margin-top: 3em;
}

.categoryWrapper{
  height: 230px;
  width: 30%;
  background: url("../../assets/bitaGame.png") no-repeat center center;
  background-size: contain;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

.categoryWrapper:after{
  position: absolute;
  top:0;
  left: 0;
  right:0;
  bottom: 0;
  backdrop-filter: blur(10px);
  content: '';
  opacity: 0;
  -webkit-transition: opacity 0.4s ease 0s;
}

.categoryWrapper:hover:after{
  opacity: 0.4;
}

.categoryWrapper h1{
  color:black;
  opacity: 0;
  font-size: 50px;
  letter-spacing: 2px;
  -webkit-transition: all 0.15s ease 0s;
  position: relative;
  z-index: 10;
}

.categoryWrapper:hover h1{
  transform: translateY(-10px);
  opacity: 1;
}

.categoryWrapper button{
  position: absolute;
  transform: translatey(60px);
  -webkit-appearance: none;
  border: none;
  background: none;
  color:black;
  width: 250px;
  height:50px;
  font-size: 20px;
  padding: 0;
  margin: 0;
  outline: none;
  z-index: 10;
}

.categoryWrapper button span{
  display: block;
  position: relative;
  line-height: 50px;
  height: 50px;
  cursor: pointer;
}

.categoryWrapper button > span:after{
  content:'';
  position: absolute;
  top:0;
  left: 50%;
  width: 20px;
  height: 0;

  border: 1px solid white;
  border-left: none;
  border-bottom: none;

  transition: height 0.15s ease-out, width 0.15s ease-out 0.15s;
}

.categoryWrapper:hover button > span:after{
  width: calc(50% - 1px);
  height: calc(100% - 2px);
  transition: width 0.15s ease-out, height 0.15s ease-out 0.15s;
}

.categoryWrapper button > span:before{
  content:'';
  position: absolute;
  top:0;
  right: 50%;
  width: 20px;
  height: 0;

  border: 1px solid white;
  border-right: none;
  border-bottom: none;

  transition: height 0.15s ease-out, width 0.15s ease-out 0.15s;
}

.categoryWrapper:hover button > span:before{
  width: calc(50% - 1px);
  height: calc(100% - 2px);
  transition: width 0.15s ease-out, height 0.15s ease-out 0.15s;
}

.categoryWrapper button > span > span:before{
  content:'';
  position: absolute;
  bottom:0;
  right: 0%;
  width: 1px;
  height: 1px;
  opacity: 0;

}

.categoryWrapper:hover button > span > span:before{
  opacity: 1;
  border-bottom: 1px solid white;
  width: calc(50%);
  height: 1px;
  transition: opacity 0s ease-out 0.29s, width 0.15s ease-out 0.3s;
}

.categoryWrapper button > span > span:after{
  content:'';
  position: absolute;
  bottom:0;
  left: 0%;
  width: 1px;
  height: 1px;
  opacity: 0;

}

.categoryWrapper:hover button > span > span:after{
  opacity: 1;
  border-bottom: 1px solid white;
  width: calc(50%);
  height: 1px;
  transition: opacity 0s ease-out 0.29s, width 0.15s ease-out 0.3s;
}

.categoryWrapper button > span > span > span{
  transition: color 0.15s ease-out 0.3s;
  color: transparent;
}

.categoryWrapper:hover button > span > span > span{
  color:black;
}

.categoryWrapper button > span > span > span:after{
  position: absolute;
  top:0;left:0;right:0;bottom:0;
  color:#1f2e4d;
  content: attr(data-attr-span);
  width: 0%;
  height: 100%;
  background:transparent;
  white-space: nowrap;
  text-align: center;
  margin: auto;
  overflow: hidden;
  display: flex;
  justify-content: center;
  transition: width 0.2s;
}

.categoryWrapper button:hover > span > span > span:after{
  width: 100%;
}

</style>