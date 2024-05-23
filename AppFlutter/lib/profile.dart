// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/showPost.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:json_annotation/json_annotation.dart';

class InstagramProfileScreen extends StatefulWidget {
  @override
  _InstagramProfileScreenState createState() => _InstagramProfileScreenState();
}

class ProfileInfo {
  int? id;
  String userName;
  String email;
  String image;
  int? followerCount;
  int? followingCount;
  bool? isFollowing;
  bool? isFollower;
  ProfileInfo({
    required this.id,
    required this.userName,
    required this.email,
    required this.image,
    required this.followerCount,
    required this.followingCount,
    required this.isFollowing,
    required this.isFollower,
  });
}

class User {
  int? id;
  String userName;
  String email;
  String image;
  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.image,
  });
}

class PostInfo {
  String title;
  User author;
  String description;
  String content;
  String? created_at;
  List<User> savedby;
  List<User> likedby;
  PostInfo({
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.created_at,
    required this.savedby,
    required this.likedby,
  });
}

class _InstagramProfileScreenState extends State<InstagramProfileScreen> {
  Future<List<PostInfo?>> getPosts() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      final response = await HttpClient.instance.get('api/posts/',
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      if (response.statusCode == 200) {
        List<PostInfo> postInfos = [];
        for (var i in response.data) {
          List<User> likedby = [];
          List<User> savedby = [];
          for (var j in i["liked_by"]) {
            User myUser = User(
                id: j["id"],
                userName: j["username"],
                email: j["email"],
                image: j["image"]);
            likedby.add(myUser);
          }
          for (var j in i["saved_by"]) {
            User myUser = User(
                id: j["id"],
                userName: j["username"],
                email: j["email"],
                image: j["image"]);
            savedby.add(myUser);
          }
          PostInfo newPostInfo = PostInfo(
              title: i["title"],
              author: User(
                  id: i["author"]["id"],
                  userName: i["author"]["username"],
                  email: i["author"]["email"],
                  image: i["author"]["image"]),
              savedby: savedby,
              likedby: likedby,
              description: i["description"],
              content: i["content"],
              created_at: i["created_at"]);
          postInfos.add(newPostInfo);
        }
        return postInfos;
      } else {
        return [];
      }
    }
    return [];
  }

  Future<ProfileInfo?> getProfileInfo() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      final response = await HttpClient.instance.get('api/complete-user/me/',
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      if (response.statusCode == 200) {
        ProfileInfo myProfile = ProfileInfo(
            id: response.data["id"],
            userName: response.data["username"],
            email: response.data["email"],
            image: response.data["image"],
            followerCount: response.data["followers_count"],
            followingCount: response.data["followings_count"],
            isFollowing: response.data["is_following"],
            isFollower: response.data["is_follower"]);
        return myProfile;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, ' > Profile'),
      body: FutureBuilder<ProfileInfo?>(
          future: getProfileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator()
                );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80,
                    child: ClipOval(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl:
                              'http://10.0.2.2:8000/api${snapshot.data?.image}',
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.error)),
                          fit: BoxFit.cover,
                          width: 160,
                          height: 160,
                        ),
                      ),
                    ),
                    // backgroundImage: NetworkImage(
                    //     'http://10.0.2.2:8000/api${snapshot.data?.image}'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    snapshot.data!.userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Followers: ${snapshot.data!.followerCount}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Following: ${snapshot.data!.followingCount}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 2 / 4, 40),
                        backgroundColor: Colors.blueAccent, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                          side: BorderSide(color: Colors.blue),
                          // Border color
                        ),
                        elevation: 5, // Shadow depth
                      ),
                      onPressed: () {
                        // Action to perform when button is pressed
                      },
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<List<PostInfo?>>(
                      future: getPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator()
                            );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  // Replace with actual content (images, posts, etc.)
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          boxShadow: [
                                            BoxShadow(blurRadius: 2)
                                          ]),
                                      child: InkWell(
                                        onTap: () {
                                          ShowPost showPost = ShowPost();
                                          showPost.declarePost(
                                              snapshot.data![index]);

                                          Navigator.of(context).pushReplacement(
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return showPost;
                                          }));
                                        },
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'http://10.0.2.2:8000/api${snapshot.data![index]!.content}',
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        Center(
                                                          child: CircularProgressIndicator()
                                                          )),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Center(
                                                    child: Icon(Icons.error)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  // Replace with actual post count
                                }),
                          );
                        } else {
                          return const Center(child: Text('No data'));
                        }
                      }),
                ],
              );
            } else {
              return const Center(child: Text('No data'));
            }
          }),
    );
  }
}