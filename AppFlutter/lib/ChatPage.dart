// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/profile.dart';
import 'package:flutter_application_2/websocketManage.dart';

class ChatPage extends StatefulWidget {
  _ChatPageState chatPageState = _ChatPageState();
  @override
  _ChatPageState createState() => chatPageState;
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
  WebSocketManager webSocketClient =
      WebSocketManager(url: 'ws://10.0.2.2:8000/ws/group/1/');
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      //webSocketClient.channel.sink.add(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    //webSocketClient.groupIdSet(1);
    return Scaffold(
      appBar: myAppBar(context, ''),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
                stream: webSocketClient.channel!.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return messageBlockBuilder(snapshot);
                  else if (snapshot.hasError)
                    return Text('${snapshot.error}');
                  else if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else
                    return Text('no data');
                }),
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
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
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
