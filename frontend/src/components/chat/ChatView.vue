<template>
  <div class="container mt-5">
    <div class="row clearfix">
      <div class="col-lg-12">
        <div class="card chat-app">
          <div id="plist" class="people-list">
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
            <ul class="list-unstyled chat-list mt-2 mb-0" v-else>
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
                    <button class="btn btn-success" style="background-color: green;" v-if="(user.id === this.currentChatRoom.creator.id || (isGroupAdmin(user.id) && isGroupAdminStaff(user.id))) && (member.id !== this.currentChatRoom.creator.id && !isGroupAdmin(member.id))" @click="set_admin(member.id,false)">set admin</button>
                    <small v-if="isGroupAdmin(member.id)"><b>admin</b></small>
                    <small v-if="member.id === currentChatRoom.creator.id"><b>creator</b></small>
                    <p>last seen</p>
                  </div>
                  <hr/>
                </div>
                <button class="btn btn-success" style="background-color: red;" v-if="user.id == currentChatRoom.creator.id || isGroupAdmin(user.id)" @click="goToAddParticipants(currentChatRoom.id)">add participants</button>
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
            <div class="chat-header clearfix">
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
                      <div class="d-flex align-items-center small" style="gap: 10px">
                        <h6 class="mb-0" v-if="!isPrivate">{{ currentChatRoom.name }} </h6>
                        <span> Created By {{
                            this.isPrivate ? currentPrivateRoom.creator.username : currentChatRoom.creator.username
                          }}</span>
                      </div>
                      <small v-if="!isPrivate">{{ currentChatRoom.participants.length }} Members</small>
                      <div v-if="isTyping">{{this.isTypingUser.username}} is typing...</div>
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
            <div class="chat-history" id="chat-history" ref="chatHistory">
              <ul class="m-b-0" id="chatList">
                <div v-for="(message) in messages" :key="message.id"
                     @contextmenu.prevent="onContextMenu($event, message.body, message.id)"
                      style="margin-bottom: 2em">
<!--                  <div v-show="changeTime" class="time-stamp"-->
<!--                       style="margin: 0 auto; background: red; text-align: center; width: fit-content">-->
<!--                    {{ showTime(getFormattedDate(message.timestamp)) }}-->
<!--                  </div>-->
                  <li class="clearfix"
                      :style="message.sender.id === user.id ? `text-align: end` : `text-align: start`">
                    <div v-if="message.sender.id === user.id">
                      <div :ref="message.id" class="message-data text-right">
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
                        <!-- @click="goToRepliedMessage" -->
                        <!--  {{ repliedText }} -->

                        <div v-if="message.reply_to != null" class="repliedMessage" @click="goToRepliedMessage(message.reply_to.id)">
<!--                          <a :href="'#/chat/#' + `${message.reply_to.id}`">-->
<!--                            <p>{{message.reply_to.id}}</p>-->
                            <p style="font-weight: bold;" class="m-0">{{message.reply_to.sender.username}}</p>
                            <p class="m-0">{{ message.reply_to.body }}</p>
<!--                          </a>-->
                        </div>

                        <div>
                          {{ message.body }}
                        </div>
                        <div style="text-align: start; font-size: small">
                          {{ getFormattedTime(message.timestamp) }}
                        </div>
                      </div>
                    </div>
                    <div v-else>
                      <div class="message-data" :ref="message.id">
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
                        <!-- @click="goToRepliedMessage" -->
                        <!--  {{ repliedText }} -->
                        <div v-if="message.reply_to != null" class="repliedMessage" @click="goToRepliedMessage(message.reply_to.id)">
<!--                          <a :href="`/  chat/#${message.reply_to.id}`">-->
<!--                          <p>{{message.reply_to.id}}</p>-->
                          <p style="font-weight: bold;" class="m-0">{{message.reply_to.sender.username}}</p>
                          <p class="m-0">{{ message.reply_to.body }}</p>
<!--                        </a>-->
                        </div>
                        <div>
                          {{ message.body }}
                        </div>
                        <div style="text-align: end; font-size: small">
                          {{ getFormattedTime(message.timestamp) }}
                        </div>
                      </div>
                    </div>
                  </li>
                </div>
              </ul>
            </div>
            <div class="chat-message clearfix">
              <div v-show="isReply" ref="repliedMessage" class="alert alert-success mb-0" role="alert">
                <div class="d-flex justify-content-between align-items-center">
                  <div></div>
                  <div>
                    <span @click="cancelReply" class="close d-flex align-items-center">&times;</span>
                  </div>
                </div>
              </div>
              <div v-show="isEdit" ref="editedMessage" class="alert alert-info mb-0" role="alert"></div>
              <div class="input-group mb-0">
                <div class="input-group-prepend">
                  <span class="input-group-text"><i class="fa fa-send"></i></span>
                </div>
                <input @input="startTyping" @keyup.enter="sendMessage()" v-model="new_message_body" type="text"
                       class="form-control"
                       ref="inputMessage"
                       placeholder="Enter text here...">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

// flexible the #chat-history
// add user private chats to front         ok
// fix reply                               ok
// add group and add private chat          ok
// able to add admin to a group --erfan
// fix token expiration** --erfan          ok
// add participants (not complete)         ok
// last seen
// who send message                        ok
// profile (posts), user profile (about & posts)
// loading icon for fetch messages,main page and etc
// is typing      ok
// add private chat creation
// enter in login page (or signup)         ok
// href and a tag for replied messages
// loading icon for fetching messages
// send btn
// min height for chat log & min width for messages
// is staff field for set admin
// remain group with reload
// more options in context menu (bring from chatroom)
// close button for reply
// got to profile in search result
// footer isn't at the bottom of the page

import {JWTAuth} from "../../../services/jwt";
import axios from "axios";
import ReconnectingWebSocket from "@/lib/reconnecting-websocket.min";
import {nextTick} from 'vue';
import "../../../node_modules/bootstrap/dist/css/bootstrap.css";

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
import debounce from "lodash/debounce";


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
    // chatHistory,
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
          admins:[{
            supervisor:{},
            user:{},
          }]
        }
      ],
      currentUser: Object,
      newGroupId: 0,
      currentChatRoom:{
        creator: {},
        participants: [{}],
        admins:[{
          supervisor:{},
          user:{}
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
      isTypingUser:{},
      repliedId: null,
      editedId: null,
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
              console.log("Replyyyy", this.$refs.repliedMessage.childNodes[0].childNodes[0]);
              this.$refs.repliedMessage.childNodes[0].childNodes[0].innerHTML = message;
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
            onClick: () => {
              alert("delete");
            }
          },
          {
            label: "A submenu",
            children: [
              {label: "Item1"},
              {label: "Item2"},
              {label: "Item3"},
            ]
          },
        ]
      });
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
      // console.log("goToRepliedMessage", el.parentNode);
      el.scrollIntoView({behavior: "smooth"});
    },
    async scrollToEnd() {
      await nextTick();
      let container = document.getElementById("chat-history");
      container.scrollTop = container.scrollHeight;
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
          }
        }))
      }
      this.repliedId = null;
      this.isReply = false;
      this.isEdit = false;
    },
    async set_admin(user_id,is_staff){
      this.websocket.send(JSON.stringify({
        "command":"set_admin",
        "user":user_id,
        "is_staff":is_staff
      }))
    },
    async selectRoom(room) {
      // console.log(JSON.stringify(this.currentChatRoom),JSON.stringify(room));
      let jsonRoom=JSON.stringify(room);
      if (JSON.stringify(this.currentChatRoom)==jsonRoom || JSON.stringify(this.currentPrivateRoom)==jsonRoom){
        return;
      }
      this.isPrivate ? this.currentPrivateRoom = {...room} : this.currentChatRoom = {...room};

      await this.handleRoom(room.id, this.isPrivate ? chatType.PRIVATE : chatType.GROUP);

      setInterval(async () => {
        if (!await jwtAuth.isAuthenticate())
          this.$router.push('/login')
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
      this.websocket.onmessage = async(event) => {
        let data = JSON.parse(event.data);
        if (!('command' in data)) {
          // message received from server
          console.log(data.error);
        } else {
          let command = data["command"]
          if (command === "fetch_messages") {
            console.log(data);
            this.messages = data["messages"];
            await this.scrollToEnd();
          }
          else if (command === "new_message") {
            console.log(data['data']);
            this.new_message = data['data'];
            this.messages.push(this.new_message);
            this.new_message_body = '';
            await this.scrollToEnd();

          }
          else if (command==="set_admin"){
            console.log(data);
          }
          else if (command==="is_typing"){
            console.log("typing");
            this.isTyping=true;
            this.isTypingUser=data.data;
          }
          else if (command==="stop_typing"){
            // console.log("stop");
            this.isTyping=false;
          }
        }
      }
    },

    goToGroupCreationForm() {
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
        "command":"is_typing",
      }))
      this.debounceStopTyping();
    },
    debounceStopTyping: debounce(function () {
      this.websocket.send(JSON.stringify({
        "command":"stop_typing"
      }))
      this.isTyping = false;
    }, 1000),
    showTime(newDate) {
      console.log("showTime", newDate)
      this.timeStamp = newDate;
      return this.timeStamp;
    },
    isGroupAdmin(userId){
      // console.log(this.currentChatRoom);

      let admins=this.currentChatRoom.admins;
      // console.log(admins);
      let result=admins.some((admin) => admin.user.id == userId);
      return result;

    },
    isGroupAdminStaff(userId){
      let admins=this.currentChatRoom.admins;
      let result=admins.find((admin) => admin.user.id == userId).is_staff;
      return result;
    },
    goToAddParticipants(groupID){
      this.$router.push(`/group/add/${groupID}`)
    }

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
    if (!await jwtAuth.isAuthenticate())
          this.$router.push('/login')
    // if (!this.isPrivate){

    //   await this.fetchGroups()
    // }
    // else
    //   await this.fetchPrivateRooms()
  },
  created() {
    // this.currentChatRoom=null;
  }
}
</script>

<style scoped>

#chat-history {
  max-height: 500px; /* Set a maximum height to enable scrolling */
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
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}

</style>