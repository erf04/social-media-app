<template>
  <div class="container mt-5">
    <div class="row clearfix">
      <div class="col-lg-12">
        <div class="card chat-app">
          <div id="plist" class="people-list">
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="fa fa-search"></i></span>
              </div>
              <input type="text" class="form-control" placeholder="Search...">
            </div>
            <ul class="list-unstyled chat-list mt-2 mb-0">
              <li class="clearfix" v-for="group in groups" :key="group.id">
                <button @click="GoToSelectedChat(group.id, group.name)">
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
          </div>
          <div v-if="groupNumber !== -1" class="offcanvas offcanvas-start" data-bs-scroll="true" tabindex="-1"
               id="offcanvasWithBothOptions"
               aria-labelledby="offcanvasWithBothOptionsLabel">
            <div class="offcanvas-header p-0">
              <img :src="getAbsoluteUrl(groups[groupNumber].image)" style="max-height: 200px; width: 100%"/>
              <button style="position: absolute; top: 10px; right: 10px; background-color: red;" type="button"
                      class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
              <!--              <h5 class="offcanvas-title" id="offcanvasWithBothOptionsLabel">Backdrop with scrolling</h5>-->
            </div>
            <div class="offcanvas-body">
              <h6>This group created in {{ groups[groupNumber].creation_date }}.</h6>
              <h2>Members</h2>
              <div v-for="member in groups[groupNumber].participants" :key="member.id" class="d-flex"
                   style="gap: 10px; padding-left: 20px">
                <img :src="getAbsoluteUrl(member.image)" style="width: 30px; height: 30px; border-radius: 50%"/>
                <div>
                  <h3>{{ member.username }}</h3>
                  <p>last seen</p>
                </div>
                <hr/>
              </div>
            </div>
          </div>
          <div class="chat" v-if="groupNumber !== -1">
            <div class="chat-header clearfix">
              <div class="row">
                <div class="col-lg-6">
                  <button style="text-align: start" type="button" data-bs-toggle="offcanvas"
                          data-bs-target="#offcanvasWithBothOptions" aria-controls="offcanvasWithBothOptions">
                    <a href="javascript:void(0);" data-toggle="modal" data-target="#view_info">
                      <img :src="getAbsoluteUrl(groups[groupNumber].image)" alt="avatar">
                    </a>
                    <div class="chat-about">
                      <div class="d-flex align-items-center small" style="gap: 10px">
                        <h6 class="mb-0">{{ groups[groupNumber].name }} </h6>
                        <span> Created By {{ groups[groupNumber].creator.username }}</span>
                      </div>
                      <small>{{ groups[groupNumber].participants.length }} Members</small>
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
                <li v-for="(message, index) in messages" :key="message.id" class="clearfix"
                    @contextmenu.prevent="showOptions(index)">
                  <div class="message-data text-right">
                    <div class="options" ref="optionsMenu">
                      <ul>
                        <li>
                          <button @click="showRepliedMessage(message)">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                 stroke="currentColor" class="w-6 h-6 me-2">
                              <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M9 15 3 9m0 0 6-6M3 9h12a6 6 0 0 1 0 12h-3" style="width: 20px; height: 20px"/>
                            </svg>
                            Reply
                          </button>
                        </li>
                      </ul>
                    </div>
                    <span class="message-data-time">
                      <span v-if="getFormattedDate(message.timestamp) === todayTime"> Today </span>
                      <span v-else-if="getFormattedDate(message.timestamp) === yesterdayTime"> Yesterday </span>
                      <span v-else> {{ message.timestamp }} </span>
                    </span>
                    <img :src="getAbsoluteUrl(message.sender.image)" alt="user profile picture"/>
                  </div>
                  <div class="message other-message float-right">{{ message.body }}</div>
                </li>
                <!-- New Message(s) #### Totally Writing Correctly After Backend Issue is Fixed -->
                <!--                <li class="clearfix">-->
                <!--                  <div class="message-data text-right" @contextmenu.prevent="showOptions($event)">-->
                <!--                    <div class="options">-->
                <!--                      <ul>-->
                <!--                        <li>-->
                <!--                          <button @click="showRepliedMessage(new_message.body)">-->
                <!--                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"-->
                <!--                                 stroke="currentColor" class="w-6 h-6 me-2">-->
                <!--                              <path stroke-linecap="round" stroke-linejoin="round"-->
                <!--                                    d="M9 15 3 9m0 0 6-6M3 9h12a6 6 0 0 1 0 12h-3" style="width: 20px; height: 20px"/>-->
                <!--                            </svg>-->
                <!--                            Reply-->
                <!--                          </button>-->
                <!--                        </li>-->
                <!--                      </ul>-->
                <!--                    </div>-->
                <!--                    <span class="message-data-time">-->
                <!--                      <span v-if="getFormattedDate(new_message.timestamp) === todayTime"> Today </span>-->
                <!--                      <span v-else-if="getFormattedDate(new_message.timestamp) === yesterdayTime"> Yesterday </span>-->
                <!--                      <span v-else> {{ new_message.timestamp }} </span>-->
                <!--                    </span>-->
                <!--                    <img :src="getAbsoluteUrl(new_message.sender.image)" alt="user profile picture"/>-->
                <!--                  </div>-->
                <!--                  <div class="message other-message float-right">{{ new_message.body }}</div>-->
                <!--                </li>-->
                <!-- ############################################################################ -->
              </ul>
            </div>

            <div class="chat-message clearfix">
              <div class="input-group mb-0">
                <div class="input-group-prepend">
                  <span class="input-group-text"><i class="fa fa-send"></i></span>
                </div>
                <div ref="repliedMessage" class="alert alert-success" role="alert"></div>
                <input @keyup.enter="sendMessage" v-model="new_message_body" type="text" class="form-control"
                       placeholder="Enter text here...">
              </div>
            </div>
          </div>
          <!--          <chat-history :groupInfo="groups[groupNumber]" />-->
        </div>
      </div>
    </div>
  </div>
</template>

<script>

// import ReconnectingWebSocket from "../lib/reconnecting-websocket.min.js";
import {JWTAuth} from "../../services/jwt";
import axios from "axios";
import ReconnectingWebSocket from "@/lib/reconnecting-websocket.min";
import router from "@/router";
// import "https://code.jquery.com/jquery-3.7.1.min.js";

const jwtAuth = new JWTAuth("http://localhost:8000/auth");
// const user = await jwtAuth.getCurrentUser();

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
          participants: [{}]
        }
      ],
      groupNumber: -1,
      groupName: 0,
      currentUser: Object,
      newGroupId: 0,
    }
  },
  computed: {},
  methods: {
    scroll(speed, num) {
      /* eslint-disable */
      let ht = 0;
      for (let i = 0; i !== num; i++) ht += $(".clearfix")[i].clientHeight;
      ht += 30;
      // let content_menu = document.getElementById('chat-history');
      $("#chat-history").animate({scrollTop: ht}, speed);
    },
    showRepliedMessage(message) {
      console.log("message showRepliedMessage", message);
      this.$refs.repliedMessage.style.display = 'block';
      this.$refs.repliedMessage.innerText = message.body;
    },
    showOptions(n) {
      this.$refs.optionsMenu[n].style.display = "block";
    },
    getFormattedDate(date) {
      return date.split(" ")[0].trim();
    },
    async sendMessage() {
      console.log("open");
      this.websocket.send(JSON.stringify({
        "command": "new_message",
        "message": {
          "body": this.new_message_body,
          "reply_to_id": null,
        }
      }))

    },
    GoToSelectedChat(n, name) {
      this.groupNumber = n - 1;
      this.groupName = name;
      router.push({name: 'chat', params: {name}});
      this.kirKhar(n);
    },

    getAbsoluteUrl(relativeUrl) {
      return relativeUrl = 'http://localhost:8000/api' + relativeUrl;
    },

    async kirKhar(id) {
      this.currentUser = await jwtAuth.getCurrentUser();
      console.log("this.groupNumber", this.groupNumber);
      this.websocket = new ReconnectingWebSocket(`ws://localhost:8000/ws/group/${id}/?token=${await jwtAuth.getAccessToken()}`);
      this.websocket.onopen = () => {
        // console.log("new group id", this.groupInfo.id);
        this.websocket.send(JSON.stringify({
          "command": "fetch_messages",
        }))
      }
      this.websocket.onclose = () => {
        console.log("close");
        // console.log(event.data);
      }
      this.websocket.onmessage = (event) => {
        let data = JSON.parse(event.data);
        if (!('command' in data)) {
          // message received from server
          console.log(data.error);
        } else {
          let command = data["command"]
          if (command === "fetch_messages") {
            console.log(data);
            this.messages = data["messages"];
          } else if (command === "new_message") {
            console.log(data['data']);
            this.new_message = data['data'];
            this.messages.push(this.new_message);
            this.new_message_body = '';
          }
        }
        // this.$refs.chatHistory.scrollTop = 99999999;
        this.scroll(9999999, 9999999);
        // let content_menu = document.getElementById('chat-history');
        // content_menu.scrollIntoView({behavior: 'smooth', block: 'end'});
      }
    },
  },
  watch: {
    groupInfo(n) {
      console.log("new", n.id);
      this.newGroupId = n.id;
    },
    groupNumber(n) {
      this.groupNumber = n;
      console.log("groupNumber", this.groupNumber);
      // this.kirKhar();
    }
  },
  async mounted() {

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
}
</script>

<style scoped>

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

.options {
  width: 80px;
  height: 100px;
  background-color: #525252;
  border: 1px solid gray;
  border-radius: 5px;
//position: absolute; display: none;
  z-index: 9;
//top: 0; //left: 0;
}

</style>