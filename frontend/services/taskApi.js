import axios from 'axios';
import JWTAuth from './jwt';
const baseURL = 'http://localhost:8000/api/tasks';
const jwtAuth=new JWTAuth('http://localhost:8000/auth');


const taskApi = axios.create({
  baseURL: baseURL,
  timeout: 5000,
  headers:{
    Authorization:`JWT ${await jwtAuth.getAccessToken()}`
  }
});

export default taskApi;