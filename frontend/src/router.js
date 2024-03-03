import {createRouter,createWebHashHistory} from "vue-router";
import Home from '@/components/Home.vue'
import signUp from '@/components/sign-up.vue'
import login from '@/components/log-in.vue'
import profile from '@/components/ProfileUser.vue'
import createPost from '@/components/CreatePost.vue'
import userPage from '@/components/UserPage.vue'
import profileInfo from "@/components/ProfileInfo.vue";
import profilePostList from "@/components/ProfilePostList.vue";
import chatView from "@/components/ChatView.vue";
import chatHistory from "@/components/ChatHistory.vue";

const routes = [
    {path: '/', component: Home},
    {path: '/signUp', component: signUp},
    {path: '/login', component: login},
    {path: '/profile/', component: profile},
    {path: '/profile/createPost', component: createPost},
    {path: '/:name', component: userPage},
    {path: '/profile/info', component: profileInfo},
    {path: '/profile/postsView', component: profilePostList},
    {path: '/chat', component: chatView},
    {path: '/chat/:id', component: chatHistory},
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})

export default router;