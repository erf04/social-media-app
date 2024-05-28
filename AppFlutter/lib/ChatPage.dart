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
    setAccess();
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

class Chat {
  int id;
  String name;
  User creator;
  String creationDate;
  List<User> participants;
  String? image;
  List<User>? admin;
  Chat({
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

  @override
  Widget build(BuildContext context) {
    var _channel = null;
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:8000/ws/group/1/?token=${this.myAccess}'));
    return Scaffold(
      appBar: myAppBar(context, ''),
      body: Container(
        child: Column(
          children: [
            StreamBuilder<dynamic>(
                stream: _channel?.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("IT GOES IN HAS WAITING!!!!!!!");
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("IT GOES IN HAS Error!!!!!!!");
                    webSocketClient.onError(snapshot.error);
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    print("IT GOES IN HAS DATA!!!!!!!");
                    var message = jsonDecode(snapshot.data);
                    print(message);
                    User mySender = User(
                        id: message["data"]["sender"]["id"],
                        userName: message["data"]["sender"]["username"],
                        email: message["data"]["sender"]["email"],
                        image: message["data"]["sender"]["image"]);
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
                        body: message.data["data"]["body"],
                        timeStamp: message.data["data"]["timestamp"],
                        type: message.data["data"]["type"]);
                    messages.add(newMessage);
                    return Column(
                      children: [
                        ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Column(
                                children: [
                                  Text(messages[index].body),
                                  //newMessage.sender == ;
                                  Row(
                                    children: [
                                      Text(snapshot.data["data"]["timestamp"]),
                                      //Icon(icon)
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
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
                                      borderRadius: BorderRadius.circular(10),
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
                                    _channel!.sink.add(jsonEncode(newDict));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    print("IT GOES IN NO DATA!!!!!!!");
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
                }),
          ],
        ),
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
