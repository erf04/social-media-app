// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/profile.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:flutter_application_2/websocketManage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  _ChatPageState chatPageState = _ChatPageState();

  @override
  _ChatPageState createState() {
    return chatPageState;
  }

  void setAccess() async {
    SplashScreenState.verifyAccess(chatPageState.context);
    chatPageState.myAccess = await LoginState.getAccessToken();
  }
}

class Message {
  int id;
  User sender;
  Message? replyTo;
  List<User> likedBy;
  List<User> savedBy;
  List<User> seenBy;
  String body;
  String timeStamp;
  String type;
  String? image;
  Message({
    required this.id,
    required this.sender,
    required this.likedBy,
    required this.savedBy,
    required this.seenBy,
    required this.body,
    required this.timeStamp,
    required this.type,
    this.image,
  });
}

class Group {
  int id;
  String name;
  User creator;
  String creationDate;
  List<User> participants;
  String? image;
  List<User>? admin;
  Group({
    required this.id,
    required this.name,
    required this.creator,
    required this.creationDate,
    required this.participants,
    this.image,
    this.admin,
  });
}

class _ChatPageState extends State<ChatPage> {
  Future<void> setAccess() async {
    SplashScreenState.verifyAccess(this.context);
    this.myAccess = await LoginState.getAccessToken();
  }

  String? myAccess;
  // final _channel =
  //     WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8000/ws/group/1/?token=${this.myAccess}'));
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  User currentUser = User(id: -1, userName: "", email: "", image: "");
  WebSocketManager webSocketClient =
      WebSocketManager(url: 'ws://10.0.2.2:8000/ws/group/1/');
  @override
  void initState() {
    getMyUser();
    webSocketClient.context = context;
  }

  Future<void> getMyUser() async {
    final accessToken = await SplashScreenState.verifyAccess(context);
    final myAccess = await LoginState.getAccessToken();
    final response = await HttpClient.instance.get("auth/users/me/",
        options: Options(headers: {"Authorization": "JWT $myAccess"}));
    currentUser.id = response.data["id"];
    currentUser.email = response.data["email"];
    currentUser.userName = response.data["username"];
  }

  final ScrollController _scrollController = ScrollController();
  var _channel;
  Future<void> connectToWebSocket() async {
    await SplashScreenState.verifyAccess(context);
    await LoginState.getAccessToken().then((onValue) {
      _channel = WebSocketChannel.connect(
          Uri.parse('ws://10.0.2.2:8000/ws/group/1/?token=${onValue}'));
      _channel!.sink.add(jsonEncode({"command": "fetch_messages"}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, ''),
      body: FutureBuilder<verifyToken?>(
        future: SplashScreenState.verifyAccess(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else if (snapshot.hasData && snapshot.data == verifyToken.verified) {
            return Container(
              child: Column(
                children: [
                  FutureBuilder<void>(
                      future: connectToWebSocket(),
                      builder: (context, snapshot2) {
                        return StreamBuilder<dynamic>(
                            stream: _channel?.stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                //print("IT GOES IN HAS WAITING!!!!!!!");
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                //print("IT GOES IN HAS Error!!!!!!!");
                                webSocketClient.onError(snapshot.error);
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                //print("IT GOES IN HAS DATA!!!!!!!");
                                var message = jsonDecode(snapshot.data);
                                //print(message);
                                //print(message["command"]);
                                if (message["command"] == "fetch_messages") {
                                  for (var i in message["messages"]) {
                                    User mySender = User(
                                        id: i["sender"]["id"],
                                        userName: i["sender"]["username"],
                                        email: i["sender"]["email"],
                                        image: i["sender"]["image"]);
                                    List<User> likedBy = [];
                                    for (var j in i["liked_by"]) {
                                      User myLikedBy = User(
                                          id: j["id"],
                                          userName: j["username"],
                                          email: j["email"],
                                          image: j["image"]);
                                      likedBy.add(myLikedBy);
                                    }

                                    List<User> savedBy = [];
                                    for (var j in i["saved_by"]) {
                                      User mySavedBy = User(
                                          id: j["id"],
                                          userName: j["username"],
                                          email: j["email"],
                                          image: j["image"]);
                                      savedBy.add(mySavedBy);
                                    }

                                    List<User> seenBy = [];
                                    for (var j in i["seen_by"]) {
                                      User mySeenBy = User(
                                          id: j["id"],
                                          userName: j["username"],
                                          email: j["email"],
                                          image: j["image"]);
                                      seenBy.add(mySeenBy);
                                    }

                                    Message newMessage = Message(
                                        id: i["id"],
                                        sender: mySender,
                                        likedBy: likedBy,
                                        savedBy: savedBy,
                                        seenBy: seenBy,
                                        body: i["body"],
                                        timeStamp: i["timestamp"],
                                        type: i["type"]);
                                    messages.add(newMessage);
                                  }
                                }

                                if (message["command"] == "new_message") {
                                  User mySender = User(
                                      id: message["data"]["sender"]["id"],
                                      userName: message["data"]["sender"]
                                          ["username"],
                                      email: message["data"]["sender"]["email"],
                                      image: message["data"]["sender"]
                                          ["image"]);
                                  List<User> likedBy = [];

                                  for (var i in message["data"]["liked_by"]) {
                                    User myLikedBy = User(
                                        id: i["id"],
                                        userName: i["username"],
                                        email: i["email"],
                                        image: i["image"]);
                                    likedBy.add(myLikedBy);
                                  }

                                  List<User> savedBy = [];
                                  for (var i in message["data"]["saved_by"]) {
                                    User mySavedBy = User(
                                        id: i["id"],
                                        userName: i["username"],
                                        email: i["email"],
                                        image: i["image"]);
                                    savedBy.add(mySavedBy);
                                  }

                                  List<User> seenBy = [];
                                  for (var i in message["data"]["seen_by"]) {
                                    User mySeenBy = User(
                                        id: i["id"],
                                        userName: i["username"],
                                        email: i["email"],
                                        image: i["image"]);
                                    seenBy.add(mySeenBy);
                                  }

                                  Message newMessage = Message(
                                      id: message["data"]["id"],
                                      sender: mySender,
                                      likedBy: likedBy,
                                      savedBy: savedBy,
                                      seenBy: seenBy,
                                      body: message["data"]["body"],
                                      timeStamp: message["data"]["timestamp"],
                                      type: message["data"]["type"]);

                                  messages.add(newMessage);
                                }
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                });
                                return Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        itemCount: messages.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          bool isSentByMe;
                                          if (messages[index].sender.userName ==
                                              this.currentUser.userName) {
                                            isSentByMe = true;
                                          } else {
                                            isSentByMe = false;
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Align(
                                              alignment: isSentByMe
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: isSentByMe
                                                      ? Colors.blue[300]
                                                      : Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft: isSentByMe
                                                        ? Radius.circular(15)
                                                        : Radius.circular(0),
                                                    bottomRight: isSentByMe
                                                        ? Radius.circular(0)
                                                        : Radius.circular(15),
                                                  ),
                                                ),
                                                child: Text(
                                                  messages[index].body,
                                                  style: TextStyle(
                                                    color: isSentByMe
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                hintText: 'Type a message',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {
                                              if (_controller.text.isNotEmpty) {
                                                Map<String, dynamic> newDict = {
                                                  "command": "new_message",
                                                  "message": {
                                                    "reply_to_id": null,
                                                    "body": "",
                                                    "image": ""
                                                  }
                                                };
                                                newDict["message"]["body"] =
                                                    _controller.text;
                                                _channel!.sink
                                                    .add(jsonEncode(newDict));
                                                _controller.text = "";
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                //print("IT GOES IN NO DATA!!!!!!!");
                                return Container();
                                // return Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: TextField(
                                //           controller: _controller,
                                //           decoration: InputDecoration(
                                //             hintText: 'Type a message',
                                //             border: OutlineInputBorder(
                                //               borderRadius: BorderRadius.circular(10),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       IconButton(
                                //         icon: Icon(Icons.send),
                                //         onPressed: () {
                                //           if (_controller.text.isNotEmpty) {
                                //             Map<String, dynamic> newDict = {
                                //               "command": "new_message",
                                //               "message": {
                                //                 "reply_to_id": null,
                                //                 "body": "",
                                //                 "image": ""
                                //               }
                                //             };
                                //             newDict["message"]["body"] = _controller.text;
                                //             //print(jsonEncode(newDict));
                                //             _channel!.sink.add(jsonEncode(newDict));
                                //           }
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // );
                              }
                            });
                      }),
                ],
              ),
            );
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }

  Expanded messageBlockBuilder(AsyncSnapshot<Object?> snapshot) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            snapshot.hasData ? '${snapshot.data}' : 'nothing',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ));
  }
}
