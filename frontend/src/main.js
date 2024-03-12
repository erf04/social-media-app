import { createApp } from 'vue'
import mitt from "mitt";
import App from './App.vue'
import router from './router.js'
import $ from 'jquery'
import '@imengyu/vue3-context-menu/lib/vue3-context-menu.css'
import ContextMenu from '@imengyu/vue3-context-menu'

window.$ = $;

const emitter = mitt();
const app = createApp(App);
app.config.globalProperties.emitter = emitter;
app.use(router);
app.use(ContextMenu);
app.mount('#app');
