// src/services/api.js

import axios from 'axios';
import { JWTAuth } from './jwt';



// const baseURL = 'http://localhost:8000/auth/';

// const api = axios.create({
//   baseURL: baseURL,
//   timeout: 5000,
// });

abstract class API {
  baseURL:string
  data:any
  isAuthorized:Boolean
  jwtAuth:JWTAuth

  constructor(baseURL:string,baseAuthURL:string){
    this.baseURL=baseURL;
    this.jwtAuth=new JWTAuth(baseAuthURL);
    console.log(this.jwtAuth.api);
    
    this.data={
      baseURL:this.baseURL,
      timeout:5000
    }
  }


  async getAuthorizedRequest(){
    if (await this.jwtAuth.isAuthenticate())
      this.data.headers = {'Authorization': `JWT ${await this.jwtAuth.getAccessToken()}`};
    else
      return null;

    return axios.create(this.data);

  }










  

   
  
}
export default API;
