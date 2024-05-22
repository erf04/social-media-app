import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/profile.dart';

class ShowPost extends StatefulWidget {
  _ShowPostState myShowPost = _ShowPostState();
  @override
  _ShowPostState createState() => myShowPost;
  declarePost(PostInfo? postinfo) => myShowPost.myPost = postinfo;
}

class _ShowPostState extends State<ShowPost> {
  PostInfo? myPost;
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, ' > Post'),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: 'http://10.0.2.2:8000/api${myPost!.content}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(isLiked ? CupertinoIcons.heart_fill :CupertinoIcons.heart, size: 30,),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ),
                            Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(CupertinoIcons.chat_bubble, size: 30,),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ),
                            Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(CupertinoIcons.share, size: 30,),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
