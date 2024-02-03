<template>
    <div>
        <h2>create a task</h2>
        <form @submit.prevent="createTask">
            <label for="title">Title:</label>
            <input type="text" v-model="title" id="title" placeholder="Title" required/><br/>
            <label for="description">Description:</label>
            <input type="text" v-model="description" id="description" placeholder="description" required/><br/>
            <label for="completed">completed:</label>
            <input type="checkbox" v-model="completed" id="completed"/><br/>
            <button type="submit">submit</button>
        </form>
        
    </div>
</template>


<script>
import axios from 'axios';

export default {
    data(){
        return{
            title:'',
            description:'',
            completed:false,
        };
    },
    mounted(){

    },
    methods:{
        createTask(){
            const Task={
                title : this.title ,
                description:this.description,
                completed:this.completed
            }

            axios.post("http://localhost:8000/api/createtask/",Task)
            .then(response=>{
                console.log(`task with title ${response.data.title} created`);
            })
            .catch(error=>{
                console.log(error.data);
            })
        }
    }
}

</script>