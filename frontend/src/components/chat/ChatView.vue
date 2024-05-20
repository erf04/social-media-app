<template>
  <div class="container mt-1">
    <div class="row clearfix">
      <div class="col-lg-12">
        <div class="card chat-app">
          <div id="plist" class="people-list pt-0">
            <button type="button" class="btn btn-success" style="background-color: blue;"
                    @click="goToGroupCreationForm()">add group
            </button>
            <button type="button" class="btn btn-success" style="background-color:green;" @click="fetchPrivateRooms()">
              pv
            </button>
            <button type="button" class="btn btn-success" style="background-color:green;" @click="fetchGroups()">
              groups
            </button>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="fa fa-search"></i></span>
              </div>
              <input type="text" class="form-control" placeholder="Search..." v-model="searchValue"
                     @change="searchHandler()">
            </div>
            <ul class="list-unstyled chat-list mt-2 mb-0" v-if="!this.isPrivate">
              <li class="clearfix" v-for="group in groups" :key="group.id">
                <button @click="selectRoom(group)">
                  <img :src="getAbsoluteUrl(group.image)" alt="avatar"/>
                  <div class="about">
                    <div class="name">{{ group.name }}</div>
                    <div class="status"><i class="fa fa-circle offline"></i> {{ group.participants.length }} <span
                        v-if="group.participants.length>1"> members</span><span
                        v-else-if="group.participants.length<=1">member</span>
                    </div>
                  </div>
                </button>
              </li>
            </ul>
            <ul class="list-unstyled chat-list mb-0" v-else>
              <li class="clearfix" v-for="privateRoom in privateRooms" :key="privateRoom.id">
                <button @click="selectRoom(privateRoom)">
                  <img
                      :src="getAbsoluteUrl(privateRoom.creator.id===this.user.id?privateRoom.the_other.image:privateRoom.creator.image)"
                      alt="avatar"/>
                  <div class="about">
                    <div class="name">{{
                        privateRoom.creator.id === this.user.id ? privateRoom.the_other.username : privateRoom.creator.username
                      }}
                    </div>
                    <!-- <div class="status"><i class="fa fa-circle offline"></i> {{ group.participants.length }} <span
                        v-if="group.participants.length>1"> members</span><span
                        v-else-if="group.participants.length<=1">member</span>
                    </div> -->
                  </div>
                </button>
              </li>
            </ul>
          </div>
          <div v-if="!this.isPrivate">
            <div v-if="this.currentChatRoom !== null" class="offcanvas offcanvas-start" data-bs-scroll="true"
                 tabindex="-1"
                 id="offcanvasWithBothOptions"
                 aria-labelledby="offcanvasWithBothOptionsLabel">
              <div class="offcanvas-header p-0">
                <img :src="getAbsoluteUrl(currentChatRoom.image)" style="max-height: 200px; width: 100%"/>
                <!-- <img :src="getAbsoluteUrl(currentChatRoom.image)" style="max-height: 200px; width: 100%"/> -->
                <button style="position: absolute; top: 10px; right: 10px; background-color: red;" type="button"
                        class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                <!--              <h5 class="offcanvas-title" id="offcanvasWithBothOptionsLabel">Backdrop with scrolling</h5>-->
              </div>
              <div class="offcanvas-body">
                <h6>This group created in {{ currentChatRoom.creation_date }}.</h6>
                <h2>Members</h2>
                <div v-for="member in currentChatRoom.participants" :key="member.id" class="d-flex"
                     style="gap: 10px; padding-left: 20px">
                  <img :src="getAbsoluteUrl(member.image)" style="width: 30px; height: 30px; border-radius: 50%"/>
                  <div>
                    <h3>{{ member.username }}</h3>
                    <div ref="setAdmin" class="d-flex justify-content-between align-items-center"
                         style="gap: 5px"
                         v-if="(user.id === this.currentChatRoom.creator.id || (isGroupAdmin(user.id) && isGroupAdminStaff(user.id))) && (member.id !== this.currentChatRoom.creator.id && !isGroupAdmin(member.id))">
                      <button class="btn btn-success" style="background-color: green;"
                              @click="set_admin(member.id, setAdminStatus)">set admin
                      </button>
                      <div>
                        <label>Is staff?</label>
                        <input type="checkbox" ref="setAdminStatus" v-model="setAdminStatus" />
                      </div>
                    </div>
                    <small v-if="isGroupAdmin(member.id)"><b>admin</b></small>
                    <small v-if="member.id === currentChatRoom.creator.id"><b>creator</b></small>
                    <p>last seen</p>
                  </div>
                  <hr/>
                </div>
                <button class="btn btn-success" style="background-color: red;"
                        v-if="user.id == currentChatRoom.creator.id || isGroupAdmin(user.id)"
                        @click="goToAddParticipants(currentChatRoom.id)">add participants
                </button>
              </div>
            </div>
          </div>
          <div v-else>
            <div v-if="this.currentPrivateRoom !== null" class="offcanvas offcanvas-start" data-bs-scroll="true"
                 tabindex="-1"
                 id="offcanvasWithBothOptions"
                 aria-labelledby="offcanvasWithBothOptionsLabel">
              <div class="offcanvas-header p-0">
                <img :src="getAbsoluteUrl(currentPrivateRoom.image)" style="max-height: 200px; width: 100%"/>
                <!-- <img :src="getAbsoluteUrl(currentChatRoom.image)" style="max-height: 200px; width: 100%"/> -->
                <button style="position: absolute; top: 10px; right: 10px; background-color: red;" type="button"
                        class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                <!--              <h5 class="offcanvas-title" id="offcanvasWithBothOptionsLabel">Backdrop with scrolling</h5>-->
              </div>
              <div class="offcanvas-body">
                <h6>This private chat created in {{ currentPrivateRoom.creation_date }}.</h6>
                <h2>Members</h2>
                <!-- <div v-for="member in currentChatRoom.participants" :key="member.id" class="d-flex"
                     style="gap: 10px; padding-left: 20px">
                  <img :src="getAbsoluteUrl(member.image)" style="width: 30px; height: 30px; border-radius: 50%"/>
                  <div>
                    <h3>{{ member.username }}</h3>
                    <p>last seen</p>
                  </div>
                  <hr/>
                </div> -->
              </div>
            </div>
          </div>
          <div class="chat"
               v-if="currentChatRoom!==null || currentPrivateRoom !== null"
          >
            <div class="d-flex align-items-center justify-content-center" ref="bottomBtn" style="opacity: 0; background-color: darkcyan; border-radius: 50%; position: absolute;
                 width: 40px; height: 40px; bottom: 120px; right: 40px; z-index: 99;">
              <div>
                <button @click="scrollToEnd" style="background: none">
                  <svg style="width: 25px; height: 25px" xmlns="http://www.w3.org/2000/svg" fill="none"
                       viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5"/>
                  </svg>
                </button>
              </div>
            </div>
            <div class="chat-header clearfix pb-1">
              <div class="row">
                <div class="col-lg-6">
                  <button style="text-align: start" type="button" data-bs-toggle="offcanvas"
                          data-bs-target="#offcanvasWithBothOptions" aria-controls="offcanvasWithBothOptions">
                    <a href="javascript:void(0);" data-toggle="modal" data-target="#view_info">
                      <img
                          :src="getAbsoluteUrl(this.isPrivate? currentPrivateRoom.creator.id===user.id ? currentPrivateRoom.the_other.image:currentPrivateRoom.creator.image : currentChatRoom.image)"
                          alt="avatar">
                    </a>
                    <div class="chat-about">
                      <div class="d-flex align-items-baseline small mb-1" style="gap: 10px">
                        <h6 class="mb-0" v-if="!isPrivate">{{ currentChatRoom.name }} </h6>
                        <span> Created By {{
                            this.isPrivate ? currentPrivateRoom.creator.username : currentChatRoom.creator.username
                          }}</span>
                      </div>
                      <div class="d-flex align-items-center" style="gap: 10px">
                        <small v-if="!isPrivate">{{ currentChatRoom.participants.length }} Members</small>
                        <small class="p-0 m-0" v-if="isTyping">{{ this.isTypingUser.username }} is typing...</small>
                      </div>
                    </div>
                  </button>
                </div>
                <div class="col-lg-6 hidden-sm text-right">
                  <a href="javascript:void(0);" class="btn btn-outline-secondary"><i class="fa fa-camera"></i></a>
                  <a href="javascript:void(0);" class="btn btn-outline-primary"><i class="fa fa-image"></i></a>
                  <a href="javascript:void(0);" class="btn btn-outline-info"><i class="fa fa-cogs"></i></a>
                  <a href="javascript:void(0);" class="btn btn-outline-warning"><i class="fa fa-question"></i></a>
                </div>
              </div>
            </div>
            <div @scroll="bottomButtonHandler($event)" class="chat-history py-1" id="chat-history" ref="chatHistory">
              <ul class="m-b-0" id="chatList">
                <div v-for="(message) in messages" :key="message.id"
                     @contextmenu.prevent="onContextMenu($event, message.body, message.id)"
                     style="margin-bottom: 1em" ref="message">
                  <!--                  <div v-show="changeTime" class="time-stamp"-->
                  <!--                       style="margin: 0 auto; background: red; text-align: center; width: fit-content">-->
                  <!--                    {{ showTime(getFormattedDate(message.timestamp)) }}-->
                  <!--                  </div>-->
                  <li class="clearfix" :id="`a${message.id}`"
                      :style="message.sender.id === user.id ? `text-align: end` : `text-align: start`">
                    <div v-if="message.sender.id === user.id">
                      <div :ref="message.id" class="message-data text-right m-0">
                        <span class="message-data-time">
                          <span v-if="getFormattedDate(message.timestamp) === todayTime"> Today </span>
                          <span v-else-if="getFormattedDate(message.timestamp) === yesterdayTime"> Yesterday </span>
                          <span v-else> {{ getFormattedDate(message.timestamp) }} </span>
                        </span>
                        <img :src="getAbsoluteUrl(message.sender.image)" alt="user profile picture"/>
                      </div>
                      <div ref="whoSend" class="message other-message">
                        <h6>
                          {{ message.sender.username }}
                        </h6>
                        <div v-if="message.reply_to != null" class="repliedMessage"
                             @click="goToRepliedMessage(message.reply_to.id)">
                          <p style="font-weight: bold;" class="m-0">{{ message.reply_to.sender.username }}</p>
                          <p class="m-0">{{ message.reply_to.body }}</p>
                          <img v-if="message.reply_to.image!==null" :src="getAbsoluteUrl(message.reply_to.image)" alt="" width="auto"
                               style="max-height: 400px; max-width: 250px" height="auto">
                        </div>
                        <div class="mt-2">
                          <img v-if="message.image!==null" :src="getAbsoluteUrl(message.image)" alt="" width="auto"
                               style="max-height: 400px; max-width: 250px" height="auto">
                          <p class="m-0">
                            {{ message.body }}
                          </p>
                        </div>
                        <div style="text-align: start; font-size: small; display: flex; align-items: baseline; gap: 10px">
                          <div style="width: 20px; height: 20px" v-if="message.seen_by.length <= 1">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                              <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
                            </svg>
                          </div>
                          <div v-else>
                            <img src="../../assets/double-tick.png" alt="seen" />
                          </div>
                          <div>
                            {{ getFormattedTime(message.timestamp) }}
                          </div>
                        </div>
                      </div>
                    </div>
                    <div v-else>
                      <div class="message-data m-0" :ref="message.id">
                        <span class="message-data-time">
    <!--                      <span> {{ message.sender.username }} </span>-->
                          <span v-if="getFormattedDate(message.timestamp) === todayTime"> Today </span>
                          <span v-else-if="getFormattedDate(message.timestamp) === yesterdayTime"> Yesterday </span>
                          <span v-else> {{ getFormattedDate(message.timestamp) }} </span>
                        </span>
                        <img :src="getAbsoluteUrl(message.sender.image)" alt="user profile picture"/>
                      </div>
                      <div class="message my-message">
                        <h6>{{ message.sender.username }}</h6>
                        <div v-if="message.reply_to != null" class="repliedMessage"
                             @click="goToRepliedMessage(message.reply_to.id)">
                          <p style="font-weight: bold;" class="m-0">{{ message.reply_to.sender.username }}</p>
                          <p class="m-0">{{ message.reply_to.body }}</p>
                          <img v-if="message.reply_to.image!==null" :src="getAbsoluteUrl(message.reply_to.image)" alt="" width="auto"
                               style="max-height: 400px; max-width: 250px" height="auto">
                        </div>
                        <div class="mt-2">
                          <img v-if="message.image!==null" :src="getAbsoluteUrl(message.image)" alt="" width="auto"
                               style="max-height: 400px; max-width: 250px" height="auto">
                          <p class="m-0">
                            {{ message.body }}
                          </p>
                        </div>
                        <div style="text-align: end; font-size: small">
                          <p> {{ getFormattedTime(message.timestamp) }} </p>
                          
                        </div>
                      </div>
                    </div>
                  </li>
                </div>
              </ul>
            </div>
            <div class="chat-message clearfix">
              <div v-show="isReply" ref="repliedMessage" class="alert alert-success mb-0 p-0 px-3" role="alert">
                <div class="d-flex justify-content-between align-items-center">
                 <div ref="replyData"></div>
                 <span @click="cancelReply" class="close">&times;</span>
                </div>
              </div>
              <div v-show="isEdit" ref="editedMessage" class="alert alert-info mb-0 p-0 px-3" role="alert"></div>
              <div class="input-group mb-0">
                <div class="input-group-prepend">
                  <span class="input-group-text" style="cursor: pointer" @click="sendMessage">
                    <svg style="width: 20px; height: 30px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" xml:space="preserve">
                      <g style="stroke: none; stroke-width: 0; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: none; fill-rule: nonzero; opacity: 1;" transform="translate(1.4065934065934016 1.4065934065934016) scale(2.81 2.81)" >
                        <path d="M 2.849 87.151 c -0.801 -0.801 -0.8 -2.099 0 -2.899 l 29.441 -29.441 c 0.8 -0.8 2.098 -0.801 2.899 0 s 0.8 2.099 0 2.899 L 5.748 87.151 C 4.947 87.952 3.649 87.952 2.849 87.151 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(80,211,161); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                        <path d="M 0.916 65.892 c -0.801 -0.801 -0.8 -2.099 0 -2.899 l 11.08 -11.08 c 0.8 -0.8 2.098 -0.801 2.899 0 c 0.801 0.801 0.8 2.099 0 2.899 l -11.08 11.08 C 3.015 66.692 1.717 66.692 0.916 65.892 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(80,211,161); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                        <path d="M 24.108 89.084 c -0.8 -0.8 -0.8 -2.099 0 -2.899 l 11.08 -11.08 c 0.8 -0.8 2.099 -0.8 2.899 0 c 0.8 0.8 0.8 2.099 0 2.899 l -11.08 11.08 C 26.207 89.884 24.909 89.884 24.108 89.084 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(80,211,161); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                        <path d="M 89.399 0.601 c -0.53 -0.53 -1.306 -0.729 -2.025 -0.518 L 1.475 25.207 c -0.778 0.228 -1.348 0.891 -1.457 1.693 c -0.086 0.642 0.136 1.278 0.582 1.724 c 0.11 0.11 0.235 0.21 0.372 0.294 l 25.292 15.628 c 0.436 0.269 0.956 0.365 1.459 0.27 l 21.538 -4.079 C 65.667 32.684 78.597 18.514 89.399 0.601 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(80,211,161); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                        <path d="M 89.399 0.601 c 0.53 0.53 0.729 1.306 0.518 2.025 L 64.793 88.525 c -0.228 0.778 -0.891 1.348 -1.693 1.457 c -0.642 0.086 -1.278 -0.136 -1.724 -0.582 c -0.11 -0.11 -0.21 -0.235 -0.294 -0.372 L 45.452 63.736 c -0.269 -0.436 -0.365 -0.956 -0.27 -1.459 l 4.079 -21.538 L 89.399 0.601 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(60,187,139); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                      </g>
                  </svg>
                  </span>
                </div>
                <input @input="startTyping" @keyup.enter="sendMessage()" v-model="new_message_body" type="text"
                       class="form-control p-2"
                       ref="inputMessage"
                       placeholder="Enter text here...">
              </div>
              <label for="img-input">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                     stroke="currentColor" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="m18.375 12.739-7.693 7.693a4.5 4.5 0 0 1-6.364-6.364l10.94-10.94A3 3 0 1 1 19.5 7.372L8.552 18.32m.009-.01-.01.01m5.699-9.941-7.81 7.81a1.5 1.5 0 0 0 2.112 2.13"/>
                </svg>
              </label>
              <input id="img-input" type="file" ref="fileInput" @change="handleFileChange">
            </div>
          </div>
          <div class="loader" id="loader"></div>
        </div>
      </div>
    </div>
  </div>
  <footerMenu/>
</template>

<script>

// flexible the #chat-history
// add user private chats to front         ok
// fix reply                               ok
// add group and add private chat          ok
// able to add admin to a group --erfan    ok
// fix token expiration** --erfan          ok
// add participants (not complete)         ok
// last seen
// who send message                        ok
// profile (posts), user profile (about & posts)
// loading icon for fetch messages,main page and etc
// is typing                               ok
// add private chat creation
// enter in login page (or signup)         ok
// href and a tag for replied messages     ok
// loading icon for fetching messages      ok
// send btn                                ok
// min height for chat log & min width for messages       ok
// is staff field for set admin        ok
// remain group with reload
// more options in context menu (bring from chatroom)     ok
// close button for reply             ok
// got to profile in search result
// footer isn't at the bottom of the page     ok
// set admin front                ok
// scroll to end btn              ok
// image in reply alert box
// online offline green circle
// send set admin message to group
// seen message 
// last message
// like and save message 

import {JWTAuth} from "../../../services/jwt";
import axios from "axios";
import ReconnectingWebSocket from "@/lib/reconnecting-websocket.min";
import "../../../node_modules/bootstrap/dist/css/bootstrap.css";
import footerMenu from '@/components/FooterMenu.vue';
import $ from 'jquery';
import debounce from "lodash/debounce";
import { nextTick } from "vue";


const jwtAuth = new JWTAuth("http://localhost:8000/auth");
const baseURL = "http://localhost:8000";

// eslint-disable-next-line no-unused-vars
const user = await jwtAuth.getCurrentUser();
// eslint-disable-next-line
const chatType = Object.freeze({
  PRIVATE: "pv",
  GROUP: "group"
})

export default {
  components: {
    footerMenu,
  },
  data() {
    return {
      messages: [],
      new_message: {
        sender: {}
      },
      todayTime: "",
      yesterdayTime: "",
      new_message_body: '',
      formatted_message_date: '',
      groups: [
        {
          creator: {},
          participants: [{}],
          admins: [{
            supervisor: {},
            user: {},
          }]
        }
      ],
      currentUser: Object,
      newGroupId: 0,
      currentChatRoom: {
        creator: {},
        participants: [{}],
        admins: [{
          supervisor: {},
          user: {}
        }]
      },
      isPrivate: false,
      privateRooms: [{
        creator: {},
        the_other: {}
      }],
      user: {},
      currentPrivateRoom: {
        creator: {},
        the_other: {}
      },
      isReply: false,
      isEdit: false,
      userInfo: {},
      searchValue: '',
      isTyping: false,
      changeTime: false,
      timeStamp: '',
      isTypingUser: {},
      repliedId: null,
      editedId: null,
      arrived: true,
      selectedImage: null,
      setAdminStatus: false,
    }
  },
  computed: {},
  methods: {
    onContextMenu(e, message, id) {
      e.preventDefault();
      console.log("contextmenu", id);
      this.$contextmenu({
        x: e.x,
        y: e.y,
        items: [
          {
            label: "Reply",
            onClick: () => {
              this.$refs.replyData.innerHTML = message;
              this.$refs.inputMessage.focus();
              this.isReply = true;
              this.repliedId = id;
            }
          },
          {
            label: "Speak",
            onClick: () => {
              const text = new SpeechSynthesisUtterance(message);
              text.rate = 1;
              speechSynthesis.speak(text);
            }
          },
          {
            label: "Edit",
            onClick: () => {
              this.$refs.editedMessage.innerText = message + this.$refs.editedMessage.innerText;
              this.isEdit = true;
              this.editedId = id;
              this.new_message_body = message;
            }
          },
          {
            label: "Copy",
            onClick: () => {
              navigator.clipboard.writeText(message);
              alert("Text Copied!");
            }
          },
          {
            label: "Delete",
            onClick: async () => {
              await axios.post(`${baseURL}/chat/message/delete/`, {
                message_id: id,
              }, {
                headers: {
                  Authorization: `JWT ${await jwtAuth.getAccessToken()}`
                }
              })
              this.arrived = false;
              this.fetchMessages();
            }
          },
          {
            label: "Seen By",
            children: [
              {label: "Item1"},
              {label: "Item2"},
              {label: "Item3"},
            ]
          },
        ]
      });
    },
    isScrolledIntoView(el) {
      var rect = el.getBoundingClientRect();
      var elemTop = rect.top;
      var elemBottom = rect.bottom;

      // Only completely visible elements return true:
      var isVisible = (elemTop >= 0) && (elemBottom <= window.innerHeight);
      return isVisible;
    },
    bottomButtonHandler(e) {
      // console.log("scrollTop", e.target.scrollTop);
      const height = e.target.scrollHeight - e.target.clientHeight;
      // if (e.target.scrollTop === e.target.scrollHeight) {
      // }
      // console.log("scrollHeight", e.target.scrollHeight);
      // console.log(e.target.scrollTop);

      this.messages.forEach(message => {
        const element = document.getElementById(`a${message.id}`);
        if (this.isScrolledIntoView(element)) {
          this.sendViewer(message.id);
          // console.log(`Div ${message.id} is in view!`);
        }
        // else {
        //   console.log(`Div ${message.id} not in view!`);
        // }
      });
      // console.log(element, "elementtttttttttttttttttttttttttt");
      // console.log(element.scrollIntoView(), "boooooooooooooooooooooooooooooooool");
      
      
      if (height - e.target.scrollTop > 300) {
        // alert("bottom btn");
        // this.$refs.bottomBtn.style.display = "block";
        this.$refs.bottomBtn.style.transition = "0.3s";
        this.$refs.bottomBtn.style.opacity = "1";
      } else {
        // this.$refs.bottomBtn.style.display = "none";
        this.$refs.bottomBtn.style.transition = "0.3s";
        this.$refs.bottomBtn.style.opacity = "0";
      }
    },
    cancelReply() {
      this.repliedId = null;
      this.isReply = false;
    },
    goToRepliedMessage(id) {
      const el = this.$refs[`${id}`][0];
      const elParent = this.$refs[`${id}`][0].parentNode;
      elParent.style.backgroundColor = "#89cbff";
      elParent.style.transition = "1s";
      setTimeout(() => {
        elParent.style.backgroundColor = "inherit";
      }, 1500);
      el.scrollIntoView({behavior: "smooth"});
    },
    imgHeights() {
      // await nextTick();
      // this.$nextTick(() => {
      const imgs = document.querySelectorAll("#chat-history img");
      let height = 0;
      imgs.forEach(img => {
        height += img.height;
      })
      // console.log("height imgsssssssssssssssssssssss" , height);
      return height;
      // })
    },
    async scrollToEnd() {
        
        await nextTick();
        let ht=0;
        // console.log($('.clearfix'));
        $("#chat-history div").each((index,el)=>{
          // console.log(el,index);
          ht+=$(el).height();
        })
        $("#chat-history").animate({scrollTop: ht});
        // this.hideLoader();
    },
    async scrollForNewMessage(){
      await nextTick();
      let container = document.getElementById("chat-history");
      container.scrollTop=container.scrollHeight;
    },
    getFormattedDate(date) {
      return date.split(" ")[0].trim();
    },
    getFormattedTime(date) {
      return date.split(" ")[1].trim();
    },
    async sendMessage() {
        if (this.isEdit) {
          console.log("should change the message body");
          this.new_message_body = '';
        } else {
          // console.log("in send");
          this.websocket.send(JSON.stringify({
            "command": "new_message",
            "message": {
              "body": this.new_message_body,
              "reply_to_id": this.repliedId,
              "image": this.base64Image
            }
          }))
        }
        this.repliedId = null;
        this.isReply = false;
        this.isEdit = false;
        this.selectedImage = null;
        this.$refs.fileInput.value = null;
        this.base64Image=null;
    },
    async set_admin(user_id, is_staff) {
      this.websocket.send(JSON.stringify({
        "command": "set_admin",
        "user": user_id,
        "is_staff": is_staff
      }))
      this.$refs.setAdmin[0].style.transition = "1s";
      this.$refs.setAdmin[0].innerHTML = is_staff ? "User status set. (Staffed)" : "User status set. (Not Staffed)";
      setTimeout(() => {
        this.$refs.setAdmin[0].style.opacity = "0";
      }, 1000);
      setTimeout(() => {
        this.$refs.setAdmin[0].innerHTML = "<small><b>admin</b></small>";
        this.$refs.setAdmin[0].style.opacity = "1";
      }, 2000);
    },
    async selectRoom(room) {
      this.showLoader();
      // setTimeout(() => {
      //   this.hideLoader();
      // }, 1500);
      // console.log(JSON.stringify(this.currentChatRoom),JSON.stringify(room));
      let jsonRoom = JSON.stringify(room);
      if (JSON.stringify(this.currentChatRoom) == jsonRoom || JSON.stringify(this.currentPrivateRoom) == jsonRoom) {
        return;
      }
      this.isPrivate ? this.currentPrivateRoom = {...room} : this.currentChatRoom = {...room};

      await this.handleRoom(room.id, this.isPrivate ? chatType.PRIVATE : chatType.GROUP);

      setInterval(async () => {
        if (!await jwtAuth.isAuthenticate()){

          if (this.websocket!=null){
            this.websocket.close()
          }
          this.$router.push('/login');
        }
        // await nextTick();
        else
          await this.handleRoom(room.id, this.isPrivate ? chatType.PRIVATE : chatType.GROUP);
        // await nextTick();
      }, 4.5 * 60 * 1000);
    },
    saveSelectedRoom() {
      localStorage.setItem('selectedRoom', JSON.stringify(this.currentChatRoom));
    },
    loadSavedRoom() {
      const savedRoom = localStorage.getItem('selectedRoom');
      return savedRoom ? JSON.parse(savedRoom) : null;
    },

    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },

    fetchMessages() {
      this.websocket.send(JSON.stringify({
        "command": "fetch_messages",
      }))
    },

    async handleRoom(id, type) {
      this.websocket = new ReconnectingWebSocket(`ws://localhost:8000/ws/${type}/${id}/?token=${await jwtAuth.getAccessToken()}`);
      this.websocket.onopen = () => {
        console.log("open");
        this.websocket.send(JSON.stringify({
          "command": "fetch_messages",
        }))
      }
      this.websocket.onclose = () => {
        console.log("close");
        // console.log(event.data);
      }
      this.websocket.onmessage = async (event) => {
        let data = JSON.parse(event.data);
        if (!('command' in data)) {
          // message received from server
          console.log(data.error);
        } else {
          let command = data["command"]
          if (command === "fetch_messages") {
            console.log(data);
            this.messages = data["messages"];
            console.log(`this.arrived:${this.arrived}`);
            if (this.arrived) {
              await this.scrollToEnd();
            }
            // $("#chat-history").scrollTop($("#chat-history").scrollHeight)
            await nextTick();
            this.hideLoader();
          } else if (command === "new_message") {
            console.log(data['data']);
            this.new_message = data['data'];
            this.messages.push(this.new_message);
            this.new_message_body = '';
            // await this.scrollToEnd();
            await this.scrollForNewMessage();
          } else if (command === "set_admin") {
            console.log(data);
          } else if (command === "is_typing") {
            console.log("typing");
            this.isTyping = true;
            this.isTypingUser = data.data;
          } else if (command === "stop_typing") {
            // console.log("stop");
            this.isTyping = false;
          } else if (command === "image") {
            console.log(data);
          }
          else if (command == "add_viewer"){
            console.log(data);
          }
        }
      }
    },

    sendViewer(id) {
      this.websocket.send(JSON.stringify({
        "message_id" : id,
        "command": "add_viewer",
      }))
    },

    goToGroupCreationForm() {
      if (this.websocket!=null)
      this.websocket.close();
      this.$router.push('/group/create');
    },
    async fetchPrivateRooms() {
      this.isPrivate = true;
      this.currentChatRoom = null;
      axios.get('http://localhost:8000/chat/pv/', {
        headers: {
          Authorization: `JWT ${await jwtAuth.getAccessToken()}`
        }
      })
          .then(result => {
            this.privateRooms = result.data;
            console.log(this.privateRooms);
          })
          .catch(error => {
            console.log(error);
          })
    },
    async fetchGroups() {
      this.isPrivate = false;
      this.currentPrivateRoom = null;
      axios.get('http://localhost:8000/chat/groups/', {
        headers: {
          Authorization: `JWT ${await jwtAuth.getAccessToken()}`
        }
      })
          .then(result => {
            this.groups = result.data;
          })
          .catch(error => {
            console.log(error);
          })
    },
    async searchHandler() {
      // console.log(this.isPrivate);
      if (!this.isPrivate) {
        let body = {
          "key": this.searchValue
        }
        axios.post(`${baseURL}/chat/groups/filter`, body, {
          headers: {
            Authorization: `JWT ${await jwtAuth.getAccessToken()}`
          }
        })
            .then(response => {
              this.groups = response.data;
            })
            .catch(err => {
              console.log(err);
            })

      } else {
        let body = {
          "key": this.searchValue
        }
        axios.post(`${baseURL}/chat/pv/filter`, body, {
          headers: {
            Authorization: `JWT ${await jwtAuth.getAccessToken()}`
          }
        })
            .then(response => {
              this.privateRooms = response.data;
            })
            .catch(err => {
              console.log(err);
            })
      }
    },
    startTyping() {
      this.isTyping = true;
      this.websocket.send(JSON.stringify({
        "command": "is_typing",
      }))
      this.debounceStopTyping();
    },
    debounceStopTyping: debounce(function () {
      this.websocket.send(JSON.stringify({
        "command": "stop_typing"
      }))
      this.isTyping = false;
    }, 1000),
    showTime(newDate) {
      console.log("showTime", newDate)
      this.timeStamp = newDate;
      return this.timeStamp;
    },
    isGroupAdmin(userId) {
      let admins = this.currentChatRoom.admins;
      let result = admins.some((admin) => admin.user.id == userId);
      return result;
    },
    isGroupAdminStaff(userId) {
      let admins = this.currentChatRoom.admins;
      let result = admins.find((admin) => admin.user.id == userId).is_staff;
      return result;
    },
    goToAddParticipants(groupID) {
      this.$router.push(`/group/add/${groupID}`)
    },
    async handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.selectedImage = file;
      }
      await this.uploadImage();
      this.$refs.inputMessage.focus();
    },
    async uploadImage() {
      if (this.selectedImage) {
        const reader = new FileReader();
        reader.readAsDataURL(this.selectedImage);
        reader.onload = () => {
          // const base64Image = reader.result.split(',')[1];
          this.base64Image = reader.result;
          // return base64Image;
          // Send base64Image through WebSocket to Django backend
          // Example: this.websocket.send(base64Image);
        };
      }
    },

    showLoader() {
      const loader = document.getElementById("loader");
      loader.style.display = "block";
    },
    hideLoader() {
      const loader = document.getElementById("loader");
      loader.style.display = "none";
    },
    pedarsag() {
      const divElement = $('#a222');
      console.log("kgatttttttttttttttttttttttttttttttttt", divElement);
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            console.log('User has reached the div');
            // Perform any action you want when user reaches the div
          }
        });
      });
      observer.observe(divElement);
    },
  },
  watch: {
    groupInfo(n) {
      console.log("new", n.id);
      this.newGroupId = n.id;
    },
    searchValue: function () {
      this.searchHandler();
    },
    timeStamp() {
      this.changeTime = true;
    }
  },

  async mounted() {
    this.user = await jwtAuth.getCurrentUser();
    // console.log("messages:"+this.messages);
    this.currentChatRoom = null;
    this.currentPrivateRoom = null;
    this.groups = null;
    // this.isPrivate=false;
    console.log(this.isPrivate);
    if (!await jwtAuth.isAuthenticate()) {
      this.$router.push('/login')
    }
    // await nextTick();
    // this.pedarsag();
    },
}
</script>

<style scoped>

#chat-history {
  max-height: 450px; /* Set a maximum height to enable scrolling */
  overflow-y: auto; /* Enable vertical scrolling */
  scroll-behavior: smooth; /* Enable smooth scroll behavior */
}

button {
  border: none;
  background-color: inherit;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

.card {
  background: #fff;
  transition: .5s;
  border: 0;
  margin-bottom: 30px;
  border-radius: .55rem;
  position: relative;
  width: 100%;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 10%);
}

.chat-app .people-list {
  width: 280px;
  position: absolute;
  left: 0;
  top: 0;
  padding: 20px;
  z-index: 7
}

.chat-app .chat {
  margin-left: 280px;
  border-left: 1px solid #eaeaea
}

.people-list {
  -moz-transition: .5s;
  -o-transition: .5s;
  -webkit-transition: .5s;
  transition: .5s
}

.people-list .chat-list li {
  padding: 10px 15px;
  list-style: none;
  border-radius: 3px
}

.people-list .chat-list li:hover {
  background: #efefef;
  cursor: pointer
}

.people-list .chat-list li.active {
  background: #efefef
}

.people-list .chat-list li .name {
  font-size: 15px
}

.people-list .chat-list img {
  width: 45px;
  border-radius: 50%
}

.people-list img {
  float: left;
  border-radius: 50%
}

.people-list .about {
  float: left;
  padding-left: 8px
}

.people-list .status {
  color: #999;
  font-size: 13px
}

.chat .chat-header {
  padding: 15px 20px;
  border-bottom: 2px solid #f4f7f6
}

.chat .chat-header img {
  float: left;
  border-radius: 40px;
  width: 40px
}

.chat .chat-header .chat-about {
  float: left;
  padding-left: 10px
}

.chat .chat-history {
  padding: 20px;
  border-bottom: 2px solid #fff
}

.chat .chat-history ul {
  padding: 0
}

.chat .chat-history ul li {
  list-style: none;
  margin-bottom: 30px
}

.chat .chat-history ul li:last-child {
  margin-bottom: 0
}

.chat .chat-history .message-data {
  margin-bottom: 15px
}

.chat .chat-history .message-data img {
  border-radius: 40px;
  width: 40px
}

.chat .chat-history .message-data-time {
  color: #434651;
  padding-left: 6px
}

.chat .chat-history .message {
  color: #444;
  padding: 18px 20px;
  line-height: 26px;
  font-size: 16px;
  border-radius: 7px;
  display: inline-block;
  position: relative
}

.chat .chat-history .message:after {
  bottom: 100%;
  left: 7%;
  border: solid transparent;
  content: " ";
  height: 0;
  width: 0;
  position: absolute;
  pointer-events: none;
  border-bottom-color: #fff;
  border-width: 10px;
  margin-left: -10px
}

.chat .chat-history .my-message {
  background: #efefef
}

.chat .chat-history .my-message:after {
  bottom: 100%;
  left: 30px;
  border: solid transparent;
  content: " ";
  height: 0;
  width: 0;
  position: absolute;
  pointer-events: none;
  border-bottom-color: #efefef;
  border-width: 10px;
  margin-left: -10px
}

.chat .chat-history .other-message {
  background: #e8f1f3;
  text-align: right
}

.chat .chat-history .other-message:after {
  border-bottom-color: #e8f1f3;
  left: 93%
}

.chat .chat-message {
  padding: 20px
}

.online,
.offline,
.me {
  margin-right: 2px;
  font-size: 8px;
  vertical-align: middle
}

.online {
  color: #86c541
}

.offline {
  color: #e47297
}

.me {
  color: #1d8ecd
}

.float-right {
  float: right
}

.clearfix:after {
  visibility: hidden;
  display: block;
  font-size: 0;
  content: " ";
  clear: both;
  height: 0
}

@media only screen and (max-width: 767px) {
  .chat-app .people-list {
    height: 465px;
    width: 100%;
    overflow-x: auto;
    background: #fff;
    left: -400px;
    display: none
  }

  .chat-app .people-list.open {
    left: 0
  }

  .chat-app .chat {
    margin: 0
  }

  .chat-app .chat .chat-header {
    border-radius: 0.55rem 0.55rem 0 0
  }

  .chat-app .chat-history {
    height: 300px;
    overflow-x: auto
  }
}

@media only screen and (min-width: 768px) and (max-width: 992px) {
  .chat-app .chat-list {
    height: 650px;
    overflow-x: auto
  }

  .chat-app .chat-history {
    height: 600px;
    overflow-x: auto
  }
}

@media only screen and (min-device-width: 768px) and (max-device-width: 1024px) and (orientation: landscape) and (-webkit-min-device-pixel-ratio: 1) {
  .chat-app .chat-list {
    height: 480px;
    overflow-x: auto
  }

  .chat-app .chat-history {
    height: calc(100vh - 350px);
    overflow-x: auto
  }
}

.repliedMessage {
  background-color: #89cbff;
  border-right: 5px solid #1d9cff;
  padding: 5px;
  color: gray;
}

.close {
  color: #aaa;
  /* float: right; */
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}

.loader {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 6px solid #f3f3f3;
  border-top: 6px solid #3498db;
  border-radius: 50%;
  width: 50px;
  backdrop-filter: opacity(0);
  height: 50px;
  animation: spin 1s linear infinite;
  /* background-color: red; */
  display: none;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

</style>