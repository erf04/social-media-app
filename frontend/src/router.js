import {createRouter,createWebHashHistory} from "vue-router";
import Home from './components/Home.vue'
import signUp from './components/sign-up.vue'
import login from './components/log-in.vue'

const routes = [
    {path: '/', component: Home},
    {path: '/signUp', component: signUp},
    {path: '/login', component: login},
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})

export default router;