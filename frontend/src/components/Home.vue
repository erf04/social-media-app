<template>
  <authTest/>
  <posts :imageSrc="imageSrc" :caption="captions.post1" />
  <posts :imageSrc="imageSrc" :caption="captions.post2" />
</template>

<script>

import authTest from './authTest.vue';
import posts from './APost.vue';

export default {
  name: 'App',
  components: {
    authTest,
    posts,
  },
  data() {
    return {
      imageSrc: '../assets/logo.png',
      captions: {
        post1: 'Hi, This is my first sagi post!',
        post2: 'Hi, This is my second sagi post!',
      }
    }
  }
}
</script>
