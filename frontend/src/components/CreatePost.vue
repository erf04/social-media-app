<template>
  <div class="container p-5 w-50">
    <div class="mb-4" style="text-align: center">
      <h1>Create Post Page</h1>
    </div>
    <div class="mb-3">
      <label for="exampleInputEmail1" class="form-label">Title</label>
      <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp">
    </div>
    <div class="mb-3">
      <label for="exampleInputEmail1" class="form-label">Description</label>
      <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp">
    </div>
    <div class="mb-3">
      <label for="exampleInputPassword1" class="form-label">Image</label>
      <input type="file" class="form-control" id="exampleInputPassword1">
    </div>
    <div style="text-align: center">
      <button type="submit" class="btn btn-primary">Submit</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  }
}
</script>

<style>
</style>