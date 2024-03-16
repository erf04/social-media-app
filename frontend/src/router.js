import {createRouter, createWebHistory} from "vue-router";
import Home from '@/components/homePage/Home.vue'
import signUp from '@/components/auth/sign-up.vue'
import login from '@/components/auth/log-in.vue'
import profile from '@/components/myProfile/ProfileUser.vue'
import createPost from '@/components/myProfile/CreatePost.vue'
import profileInfo from "@/components/myProfile/ProfileInfo.vue";
import profilePostList from "@/components/myProfile/ProfilePostList.vue";
import userPage from '@/components/userProfile/UserPage.vue'
import chatView from "@/components/chat/ChatView.vue";
import CreateGroup  from "@/components/chat/CreateGroup.vue";
import AddParticipants from  "@/components/chat/AddParticipants.vue";
import search from "@/components/SearchPage.vue"
import game from "@/components/game/PlayGame.vue";
import showGame from "@/components/game/ShowGame.vue";

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
    {path: '/group/create', component:CreateGroup },
    {path: '/group/add/:id', component:AddParticipants },
    {path: '/search', component:search },
    {path: '/game', component:game },
    {path: '/game/:name', component:showGame },
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router;