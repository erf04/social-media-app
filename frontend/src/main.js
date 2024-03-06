import { createApp } from 'vue'
import mitt from "mitt";
import App from './App.vue'
import router from './router.js'
import $ from 'jquery'


window.$ = $;

const emitter = mitt();
const app = createApp(App);
// const baseURL="http://localhost:8000/api";
// Vue.use(require('vue-moment'));
app.config.globalProperties.emitter = emitter;
app.use(router);
app.mount('#app');
