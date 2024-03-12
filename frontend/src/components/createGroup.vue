<template>
    <div class="container p-5 w-50">
      <div class="mb-4" style="text-align: center">
        <h1>Create Group Page</h1>
      </div>
      <form @submit.prevent="createPost">
      <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">group name</label>
        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" v-model="group_name">
      </div>
      <!-- <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Description</label>
        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" v-model="description">
      </div> -->
      <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Image</label>
        <input type="file" class="form-control" id="exampleInputPassword1" name="image" v-on:change="handleFileUpload"/>
      </div>
      <div style="text-align: center">
        <button type="submit" class="btn btn-primary">Submit</button>
      </div>
    </form>
    </div>
  </template>
  
  <script>
  
  import axios from 'axios';
  import { JWTAuth } from '../../services/jwt';
  import router from "@/router";
  const baseURL="http://localhost:8000";
  const jwtAuth=new JWTAuth('http://localhost:8000/auth')
  export default {
    data() {
      return {
        group_name:'',
        image:null,
      }
    },
  
    methods:{
      handleFileUpload(event){
        const file=event.target.files[0];
        this.image=file;
      },
      async createPost(){
        const formData = new FormData();
        formData.append('group_name', this.group_name);
        // formData.append('description',this.description);
        formData.append('image',this.image);
        // formData.append('created_at',new Date().toISOString());
        let access=await jwtAuth.getAccessToken();
        
        axios.post(`${baseURL}/chat/groups/`,formData,{
          headers:{
            Authorization:`JWT ${access}`,
            "Content-Type": "multipart/form-data"
          }
        })
          .then(response =>{
            console.log(response);
            router.push('/group/add');
          })
          .catch(error=>{
            console.log(error);
          })
      },

  
    }
  
  }
  </script>
  
  <style>
  </style>