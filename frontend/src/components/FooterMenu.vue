<template>
  <div class="footer">
    <button @click="GoToHome">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
           class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round"
              d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"/>
      </svg>
    </button>
    <button @click="GoToCreatePost">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
      </svg>
    </button>
    <button @click="GoToProfile">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
           class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round"
              d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/>
      </svg>
    </button>
  </div>
</template>

<script>
import {mixins} from "@/mixins";
import router from "@/router";

export default {
  mixins: [mixins],
  props: [name],
  data() {
    return {
    }
  },
  methods: {
    GoToCreatePost() {
      router.push('profile/createPost');
    },
  }
}
</script>

<style>
  .footer {
  //padding: 3rem; padding: 10px 2rem 10px 2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 100px;
    position: sticky;
    bottom: 0;
    background-color: #42b983;
    width: 100%;
    min-height: 40px;
  }

  button {
    border: none;
    background-color: inherit;
  }

  button > svg {
    width: 40px;
  }
</style>