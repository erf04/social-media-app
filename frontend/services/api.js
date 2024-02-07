// src/services/api.js

import axios from 'axios';

const baseURL = 'http://localhost:8000/auth/';

const api = axios.create({
  baseURL: baseURL,
  timeout: 5000,
});

export default api;
