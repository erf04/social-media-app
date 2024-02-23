import axios from "axios";

export const userInfo = {
    data() {
        return {
            hasan: {},
            name:'',
            posts: [
                {
                    title: "",
                    description: "",
                    content: "",
                    author: {
                        username: "",
                        image: null,
                    },
                    created_at: "",
                }
            ],
            likeFillColor: 'none',
        }
    },
    getPosts() {
        axios.get('http://localhost:8000/api/posts/all', {
            headers: {
                Authorization: `JWT ${localStorage.getItem("access_token")}`
            }
        })
            .then(response => {
                this.posts = response.data;
                console.log("response.data", response.data[0].author);
                this.hasan = response.data;
            })
            .catch(error => {
                console.log(error);
                return error;
            });
    },
}