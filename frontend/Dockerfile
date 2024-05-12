FROM node:latest AS frontend
WORKDIR /frontend
COPY ./package*.json ./
RUN npm install -g @vue/cli
RUN npm install