<template>
  <component :is="currentGame" />
</template>

<script>
import bita from "@/components/game/games/BitaGame.vue"
import guess from "@/components/game/games/GuessNumber.vue"
import {useRoute} from "vue-router";
export default {
  components: {
    bita,
    guess,
  },
  data() {
    return {
      currentGame: null,
    }
  },
  created() {
    const gameName = useRoute().params.name;
    if (gameName === "bitaGame") this.currentGame = "bita";
    else if (gameName === "guessNumber") this.currentGame = "guess";
  }
}
</script>

<style scoped>

</style>