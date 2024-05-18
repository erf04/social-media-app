import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class StoryData {
  StoryData(
      {required this.id,
      required this.name,
      required this.imageFileName,
      required this.iconFileName,
      required this.isViewed});

  final String iconFileName;
  final int id;
  final String imageFileName;
  final bool isViewed;
  final String name;
}

class Category {
  Category(
      {required this.id, required this.title, required this.imageFileName});

  final int id;
  final String imageFileName;
  final String title;
}

class PostData {
  PostData(
      {required this.id,
      required this.caption,
      required this.title,
      required this.likes,
      required this.time,
      required this.isBookmarked,
      required this.imageFileName});

  final String caption;
  final int id;
  final String imageFileName;
  final bool isBookmarked;
  final String likes;
  final String time;
  final String title;
}

class AppDatabase {
  static String limiter(String string) {
    String myStr = '';
    for (int i = 0; i < 8; i++) {
      myStr += string[i];
    }
    myStr += '...';
    return myStr;
  }

  static List<StoryData> get stories {
    return [
      StoryData(
          id: 1001,
          name: 'Emiliaaaaaaaaaaaa',
          imageFileName: 'story_9.jpg',
          iconFileName: 'category_1.png',
          isViewed: false),
      StoryData(
          id: 1002,
          name: 'Richard',
          imageFileName: 'story_10.jpg',
          iconFileName: 'category_2.png',
          isViewed: false),
      StoryData(
          id: 1003,
          name: 'Jasmine',
          imageFileName: 'story_1.jpg',
          iconFileName: 'category_3.png',
          isViewed: true),
      StoryData(
          id: 1004,
          name: 'Lucas',
          imageFileName: 'story_3.jpg',
          iconFileName: 'category_4.png',
          isViewed: false),
      StoryData(
          id: 1005,
          name: 'Isabella',
          imageFileName: 'story_4.jpg',
          iconFileName: 'category_2.png',
          isViewed: false),
      StoryData(
          id: 1006,
          name: 'Olivia',
          imageFileName: 'story_6.jpg',
          iconFileName: 'category_1.png',
          isViewed: false),
      StoryData(
          id: 1007,
          name: 'Amelia',
          imageFileName: 'story_7.jpg',
          iconFileName: 'category_4.png',
          isViewed: false),
      StoryData(
          id: 1008,
          name: 'Grace',
          imageFileName: 'story_2.jpg',
          iconFileName: 'category_3.png',
          isViewed: false),
    ];
  }

  static List<Category> get categories {
    return [
      Category(
        id: 101,
        title: 'Technology',
        imageFileName: 'large_post_1.jpg',
      ),
      Category(id: 102, title: 'Cinema', imageFileName: 'large_post_2.jpg'),
      Category(
          id: 103, title: 'Transportation', imageFileName: 'large_post_3.jpg'),
      Category(id: 104, title: 'Adventure', imageFileName: 'large_post_4.jpg'),
      Category(
          id: 105,
          title: 'Artificial Intelligence',
          imageFileName: 'large_post_5.jpg'),
      Category(id: 106, title: 'Economy', imageFileName: 'large_post_6.jpg'),
    ];
  }

  static List<PostData> get posts {
    return [
      PostData(
          id: 1,
          title: 'BMW M5 Competition Review 2021',
          caption: 'TOP GEAR',
          isBookmarked: false,
          likes: '3.1k',
          time: '1hr ago',
          imageFileName: 'small_post_1.jpg'),
      PostData(
          id: 0,
          title: 'MacBook Pro with M1 Pro and M1 Max review',
          caption: 'THE VERGE',
          isBookmarked: false,
          likes: '1.2k',
          time: '2hr ago',
          imageFileName: 'small_post_2.jpg'),
      PostData(
          id: 2,
          title: 'Step design sprint for UX beginner',
          caption: 'Ux Design',
          isBookmarked: true,
          likes: '2k',
          time: '41hr ago',
          imageFileName: 'small_post_3.jpg'),
    ];
  }

  static List<OnBoardingItems> get onBoardingItems {
    List<OnBoardingItems> items = [];
    for (int i = 0; i < 4; i++) {
      items.add(OnBoardingItems(
          title: 'Learn the abilities you desire',
          description:
              'You can use hundreds of courses on LeadLearn taught by many other people.'));
    }
    return items;
  }

  static List<Student> get students {
    List<Student> items = [];
    for (int i = 0; i < 4; i++) {
      items.add(Student(
          profilePicture:
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fcultivatedculture.com%2Flinkedin-profile-picture%2F&psig=AOvVaw1nCo4IsX4vPjaBzI4ZGK8e&ust=1711195071723000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNChnMXoh4UDFQAAAAAdAAAAABAE',
          studentId: '123',
          firstName: 'amir',
          lastName: 'sedgh',
          userName: 'amirsed',
          password: 'amir7007'));
    }
    return items;
  }

  static List<Course> get courses {
    List<Course> items = [];
    Teacher teacher = Teacher('userName', 'password', '1234',
        'https://marketplace.canva.com/EAFHfL_zPBk/1/0/1600w/canva-yellow-inspiration-modern-instagram-profile-picture-kpZhUIzCx_w.jpg',
        firstName: 'Ali',
        lastName: 'Hamze',
        trivia: 'A really great instructor');
    for (int i = 0; i < 7; i++) {
      items.add(Course(
          boolean: false,
          image: 'assets/img/posts/small/small_post_4.jpg',
          courseCategory: CourseCategory.math,
          courseName: 'math2021',
          teacher: teacher,
          students: students,
          courseDetails:
              'a very professional course that will blow your mind inside and out'));
    }
    return items;
  }
}

class OnBoardingItems {
  OnBoardingItems({required this.title, required this.description});

  final String description;
  final String title;
}

enum CourseCategory { physics, math, programming, chemistry, english }

class Course {
  Course(
      {required this.boolean,
      required this.image,
      required this.courseCategory,
      required this.courseName,
      required this.teacher,
      required this.students,
      required this.courseDetails});

  bool boolean;
  final String image;
  final CourseCategory courseCategory;
  final String courseDetails;
  final String courseName;
  final List<Student> students;
  final Teacher teacher;
}

class Student {
  Student(
      {required this.profilePicture,
      required this.studentId,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.password});

  final String firstName;
  final String lastName;
  final String password;
  final String studentId;
  final String userName;
  final String profilePicture;
}

class Teacher {
  Teacher(this.userName, this.password, this.teacherId, this.profileImage,
      {required this.firstName, required this.lastName, required this.trivia});

  final String profileImage;
  final String firstName;
  final String lastName;
  final String password;
  final String teacherId;
  final String trivia;
  final String userName;
}

class HttpClient {
  static Dio instance = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/'));
}

Future<String> getLocalIpAddress() async {
  try {
    List<InternetAddress> list = await InternetAddress.lookup('google.com');
    return list[0].address;
  } on SocketException catch (_) {
    return 'Failed to get IP address.';
  }
}

Future<List<Course>> getCourses() async {
  // var url = Uri.parse('http://localhost:8000/hello/');
  // var response = await http.get(
  //   url,
  // );
  final response = await HttpClient.instance.get('hello/');
  if (response != null)
    print(response);
  else
    print("Null");
  return [];
}
