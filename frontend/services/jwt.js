import axios from 'axios';


export var messages = [];

export class JWTAuth {


    constructor(baseURL) {

        // const baseURL = 'http://localhost:8000/auth/';
        const api = axios.create({
            baseURL: baseURL, timeout: 5000,
        });
        this.api = api;
        // console.log(this.api);
    }

    async signup(username, password, email) {
        let newUser = {
            username: username, password: password, email: email
        }

            return await this.api.post('users/', newUser)
                .then(response => {
                    console.log(response);
                    return this.login(username, password)

                })
                .catch(error => {
                    let obj = JSON.parse(error.response.request.responseText);
                    messages.push(obj);
                    return false;
                })


    }

    async login(username, password) {
        let user = {
            username: username, password: password
        }
        return await this.api.post("jwt/create", user)
            .then(response => {
                // console.log(response);
                localStorage.setItem("access_token", response.data.access);
                localStorage.setItem("refresh_token", response.data.refresh);
                // this.isLoggedIn=true;
                return true;
            })
            .catch(error => {
                // console.log(error);
                let message = JSON.parse(error.response.request.responseText);
                messages.push(message);
                return false;
            })
    }

    logout() {

        localStorage.removeItem('access_token');
        // this.isLoggedIn = false;
        return false;
    }

    async isAuthenticate() {
        let access_token = localStorage.getItem("access_token");
        if (access_token === null) {
            // this.#isAuthenticate=false;
            return false;
        }


        let body = {
            "token": access_token
        }

        return await this.api.post('jwt/verify', body)
            .then(response => {

                if (response.status === 200) {

                    return true;

                } else {
                    return false;
                }


            })
            .catch(async() => {
                console.log("need to get refreshed");

                let newAccess =await this.getNewToken();
                // console.log(`from getNewToken:${newAccess}`);

                if (newAccess == null) {
                    return false;
                } else {
                    localStorage.setItem("access_token", newAccess);
                    // this.#isAuthenticate=true;

                    return true;
                }

            })


    }

    async getNewToken() {
        let body = {
            "refresh": localStorage.getItem("refresh_token")
        };
        return await this.api.post('jwt/refresh', body)
            .then(async(response) => {
                console.log(response);
                let newAccessToken = response.data.access;
                localStorage.setItem('access_token', newAccessToken);
                // console.log("from then in getNewToken:"+newAccessToken);
                return await newAccessToken;
            })
            .catch(async(error) => {
                console.log("error in getNewToken catch"+error.data);
                return null;
            })
    }

    async getAccessToken() {
        if (await this.isAuthenticate())
            return localStorage.getItem("access_token");
        return null;
    }

    async getCurrentUser() {
        let token = await this.getAccessToken();
        if (token == null) return null;
        let body = {
            username: "test1"
        }
        return await this.api.put('users/me/', body, {
            headers: {
                Authorization: "JWT " + token
            }
        })
            .then(response => {
                return response;
            })
            .catch(() => {
                // console.log(error);
                return null;
            })
    }
}

