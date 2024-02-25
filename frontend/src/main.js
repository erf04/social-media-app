import { createApp } from 'vue'
import App from './App.vue'
import router from './router.js'
global.jQuery = require('jquery');
const $ = global.jQuery;
window.$ = $;

const app = createApp(App);

app.use(router);
app.mount('#app');
