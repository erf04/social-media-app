import {createRouter,createWebHashHistory} from "vue-router";
import Home from './components/Home.vue'
import signUp from './components/sign-up.vue'
import login from './components/log-in.vue'
import profile from './components/ProfileUser.vue'
import createPost from './components/CreatePost.vue'
import userPage from './components/UserPage.vue'

const routes = [
    {path: '/', component: Home},
    {path: '/signUp', component: signUp},
    {path: '/login', component: login},
    {path: '/profile/', component: profile},
    {path: '/profile/createPost', component: createPost},
    {path: '/:name', component: userPage},
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})

export default router;