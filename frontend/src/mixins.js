import router from "@/router";
import home from "@/components/homePage/Home.vue"

export const mixins = {
    components: [
      home,
    ],
    data() {
        return {
        }
    },
    methods: {
        GoToHome() {
            router.push('/');
        },
        GoToProfile() {
            router.push('/profile/');
        },
    }
}