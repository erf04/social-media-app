// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/loginSignUp.dart';
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
  PostInfo({
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.created_at,
  });
}

class _InstagramProfileScreenState extends State<InstagramProfileScreen> {
  // User _$UserFromJson(Map<String, dynamic> json) {
  //   return User(
  //       id: json['id'] as int,
  //       userName: json['username'] as String,
  //       email: json['email'] as String,
  //       image: json['image'] as String);
  // }

  // PostInfo _$PostInfoFromJson(Map<String, dynamic> json) {
  //   return PostInfo(
  //     title: json['title'] as String,
  //     author: _$UserFromJson(json['author']),
  //     created_at: json['dateOfBirth'],
  //     content: json['content'],
  //     description: json['description'],
  //   );
  // }

  Future<List<PostInfo?>> getPosts() async {
    verifyToken? myToken = await SplashScreenState.verifyAccess(context);
    if (myToken == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      final response = await HttpClient.instance.get('api/posts/',
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      if (response.statusCode == 200) {
        List<PostInfo> postInfos = [];
        for (var i in response.data) {
          PostInfo newPostInfo = PostInfo(
              title: i["title"],
              author: i["author"],
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
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              CupertinoIcons.back,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Assets.download.image(width: 40, height: 40)),
            const SizedBox(
              width: 12,
            ),
            Text(
              'LeadLearn > Profile',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blue, // Blue theme
      ),
      body: FutureBuilder<ProfileInfo?>(
          future: getProfileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'http://10.0.2.2:8000/api${snapshot.data?.image}'),
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
                      child: Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                      future: getPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (context, index) {
                                // Replace with actual content (images, posts, etc.)
                                return Container(
                                    margin: EdgeInsets.all(5),
                                    color: Colors.blue[100],
                                    child: Center());
                              },
                              itemCount: 10, // Replace with actual post count
                            ),
                          );
                        } else {
                          return Text('No data');
                        }
                      }),
                ],
              );
            } else {
              return Text('No data');
            }
          }),
    );
  }
}
