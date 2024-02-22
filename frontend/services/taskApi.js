import API from "./api";
// import JWTAuth from './jwt';
// const jwtAuth=new JWTAuth('http://localhost:8000/auth');


class TaskApi extends API{
     constructor(baseURL,baseAuthURL){
      super(baseURL,baseAuthURL);
     }
}

export default TaskApi;