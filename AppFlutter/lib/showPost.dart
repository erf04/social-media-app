import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/profile.dart';
import 'package:flutter_application_2/splash.dart';

class ShowPost extends StatefulWidget {
  _ShowPostState myShowPost = _ShowPostState();
  @override
  _ShowPostState createState() => myShowPost;
  declarePost(PostInfo? postinfo) => myShowPost.myPost = postinfo;
}

class _ShowPostState extends State<ShowPost> {
  Future<void> likePost() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      final response = await HttpClient.instance.post('api/post/add-like/',
          options: Options(
            headers: {
              "Authorization": "JWT $myAccess",
            },
          ),
          data: {"post_id": myPost!.postId});
    }
  }

  Future<void> removeLikePost() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      final response = await HttpClient.instance.post('api/post/remove-like/',
          options: Options(
            headers: {
              "Authorization": "JWT $myAccess",
            },
          ),
          data: {"post_id": myPost!.postId});
    }
  }

  Future<bool?> checkLikePost() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      //print(myPost!.postId);
      final response = await HttpClient.instance.post('api/post/liked/',
          options: Options(
            headers: {
              "Authorization": "JWT $myAccess",
            },
          ),
          data: {"post_id": myPost!.postId});
      if (response.statusCode == 200)
        return response.data;
      else
        return null;
    } else {
      return null;
    }
  }

  bool? isSaved = false;
  PostInfo? myPost;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, ' > Post'),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: 'http://10.0.2.2:8000/api${myPost!.content}',
                  placeholder: (context, url) => const Center(
                      child: Center(child: CircularProgressIndicator())),
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
                child: FutureBuilder<bool?>(
                    future: checkLikePost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool? isLiked = snapshot.data;
                        return IconButton(
                          icon: Icon(
                            isLiked!
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isLiked! ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isLiked!) {
                                removeLikePost();
                                //isLiked = !isLiked!;
                              } else {
                                likePost();
                                //isLiked = !isLiked!;
                              }
                            });
                          },
                        );
                      } else {
                        return IconButton(
                            icon: const Icon(
                              CupertinoIcons.heart,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {});
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.chat_bubble,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.reply,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                  icon: Icon(
                    isSaved!
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
