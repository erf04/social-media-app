<template>
  <authTest/>
  <tasksTable/>
</template>

<script>

import authTest from './authTest.vue';
import tasksTable from './tasks-Table.vue';

export default {
  name: 'App',
  components: {
    authTest,
    tasksTable,
  },
  
}
</script>
