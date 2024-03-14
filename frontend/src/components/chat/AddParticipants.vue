<template>
<div class="container mt-5 px-2">
    
    <div class="mb-2 d-flex justify-content-between align-items-center">
        
        <div class="position-relative">
            <span class="position-absolute search"><i class="fa fa-search"></i></span>
            <input class="form-control w-100" placeholder="Search by order#, name...">
        </div>
        
        <div class="px-2">
            
            <span>Filters <i class="fa fa-angle-down"></i></span>
            <i class="fa fa-ellipsis-h ms-3"></i>
        </div>
        
    </div>
    <div class="table-responsive">
    <table class="table table-responsive table-borderless">
        
      <thead>
        <tr class="bg-light">
          <!-- <th scope="col" width="5%"><input class="form-check-input" type="checkbox"></th> -->
          <th scope="col" width="5%">#</th>
          <th scope="col" width="20%">profile</th>
          <th scope="col" width="30%">Username</th>
          <th scope="col" width="30%">followers</th>
          <th scope="col" width="30%">followings</th>
          <!-- <th scope="col" width="5%"><input class="form-check-input" type="checkbox"></th> -->

          <!-- <th scope="col" class="text-end" width="20%"><span>Revenue</span></th> -->
        </tr>
      </thead>
  <tbody>
    <tr v-for="(user,index) in users" :key="user.id">
        <td>{{ ++index }}</td>
        <td> <img :src="getAbsoluteUrl(user.image)" width="25" alt=""> </td>
        <td><i class="fa fa-check-circle-o green"></i><span class="ms-1">{{user.username}}</span></td>
        <td>{{user.followers_count}}</td>
        <td>{{user.followings_count}}</td>
        <!-- <td class="text-end"><span class="fw-bolder">$0.99</span> <i class="fa fa-ellipsis-h  ms-2"></i></td> -->
        <th scope="row"><input type="checkbox" :value="user.id" v-model="participants"></th>
    </tr>
    
   
  </tbody>
</table>
  <input type="submit" @click="save()" class="btn btn-success">
  
  </div>
    
</div>
  </template>
  
<script>
  
import axios from 'axios';
import { JWTAuth } from '../../../services/jwt';
import router from "@/router";
const baseURL="http://localhost:8000";
const jwtAuth=new JWTAuth('http://localhost:8000/auth');
export default {
    data() {
      return {
        users:[{}],
        participants:[]
      }
    },
  
    methods:{
      async createPost(){
        const formData = new FormData();
        
        let access=await jwtAuth.getAccessToken();
        
        axios.post(`${baseURL}/chat/groups/`,formData,{
          headers:{
            Authorization:`JWT ${access}`,
            "Content-Type": "multipart/form-data"
          }
        })
          .then(response =>{
            console.log(response);
            router.push('/chat');
          })
          .catch(error=>{
            console.log(error);
          })
      },
      getAbsoluteUrl(relativeUrl) {
        return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
      },
      addParticipants(id){
        this.participants.push(id);
      },
      async save(){
        console.log(this.participants);
        let body={
          "participants":this.participants,
        }
        axios.post(`${baseURL}/chat/groups/add/`,body,{
          headers:{
            Authorization:`JWT ${await jwtAuth.getAccessToken()}`
          }
        })
        .then(response=>{
          console.log(response);
          this.$router.push('/chat')
        })
        .catch(err=>{
          console.log(err);
        })
      }

  
    },
    async mounted() {
        axios.get(`${baseURL}/chat/get-users/`,{
            headers:{
                Authorization:`JWT ${await jwtAuth.getAccessToken()}`
            }
        })
        .then(response=>{
            this.users=response.data;
            console.log(this.users);
        })  
        .catch(err=>{
            console.log(err);
        })

    },
  
  }
  
</script>
  
  <style>
  /* @import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@300&display=swap'); */

/* body{
    font-family: 'Open Sans', sans-serif;
    
} */
.search{
  
  top:6px;
  left:10px;
}


.green{
    
    color:green;
}
  </style>