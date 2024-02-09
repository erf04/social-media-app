
import axios from 'axios';
class JWTAuth{

    #isAuthenticate

    constructor(baseURL){

        // const baseURL = 'http://localhost:8000/auth/';
       const api = axios.create({
          baseURL: baseURL,
          timeout: 5000,
        });
        this.api=api;
        // console.log(this.api);
    }
    signup(username,password,email){
        let newUser={
          username:username,
          password:password,
          email:email
        }
        this.api.post('users/',newUser)
        .then(response=>{
          console.log(response);
          return true;
        }).catch(error=>{
          console.log(error);
          return false;
        })
    }
    async login(username,password) {
        let user={
          username:username,
          password:password
        }
        return await this.api.post("jwt/create",user)
        .then(response=>{
          // console.log(response);
          localStorage.setItem("access_token",response.data.access);
          localStorage.setItem("refresh_token",response.data.refresh);
          // this.isLoggedIn=true;
          return true;
        })
        .catch(error=>{
          console.log(error);
          return false;
        })
    }
     logout() {
       
        localStorage.removeItem('access_token');
        // this.isLoggedIn = false;
        return false;
    }
    async isAuthenticate(){
        let access_token=localStorage.getItem("access_token");
        if (access_token===null){
            // this.#isAuthenticate=false;
            return false;
        }
          
    
        let body={
          "token":access_token
        }

        return await this.api.post('jwt/verify',body)
        .then(response=>{
          
          if (response.status===200){
            // console.log(response);
            return true;
            
          }
          else{
            return false;
          }
        
          
        })
        .catch(()=>{
          console.log("need to get refreshed");
          // console.log(error);
          let newAccess=this.getNewToken();
          if (newAccess===null){
            return false;
          }
          else{
            localStorage.setItem("access_token",newAccess);
            // this.#isAuthenticate=true;
            return true;
          }
          
        })

        
    }
    getNewToken(){
        let body={
          "refresh":localStorage.getItem("refresh_token")
        };
        this.api.post('jwt/refresh',body)
        .then(response=>{
          console.log(response);
          let newAccessToken = response.data.access;
          localStorage.setItem('access_token',newAccessToken);
          return newAccessToken;
        })
        .catch(error=>{
          console.log(error);
          return null;
        })
    }

    async getAccessToken(){
        if (await this.isAuthenticate())
            return localStorage.getItem("access_token");
        return null;
    }

    async getCurrentUser(){
        let token=await this.getAccessToken();
        if (token==null)
            return null;
        let body={
          username:"test1"
        }
        return await this.api.put('users/me/',body,{
            headers:{
                Authorization: "JWT " + token
            }
        })
        .then(response=>{
            return response;
        })
        .catch(error=>{
            console.log(error);
            return null;
        })
        
    }


}

export default JWTAuth;