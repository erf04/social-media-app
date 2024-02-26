import { createApp } from 'vue'
import mitt from "mitt";
import App from './App.vue'
import router from './router.js'
global.jQuery = require('jquery');
const $ = global.jQuery;
window.$ = $;

const emitter = mitt();
const app = createApp(App);
// const baseURL="http://localhost:8000/api";

app.config.globalProperties.emitter = emitter;
app.use(router);
app.mount('#app');
