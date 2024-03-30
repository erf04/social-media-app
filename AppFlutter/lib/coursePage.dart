import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    Color mycolor = Colors.black;
    final courses = AppDatabase.courses;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Available Courses:',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: selectedIndex == index
                          ? MediaQuery.of(context).size.height * (2 / 3)
                          : 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: const [BoxShadow(blurRadius: 15)]),
                      child: Padding(
                        padding: selectedIndex == index
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.all(16.0),
                        child: selectedIndex == index
                            ? _columnMethod(courses, index, context, mycolor)
                            : _rowMethod(courses, index, context, mycolor),
                      ),
                    ),
                  );
                }),
          ),
        ],
      )),
    );
  }

  Column _columnMethod(
      List<Course> courses, int index, BuildContext context, Color mycolor) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            courses[index].image,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (selectedIndex != index) {
                          selectedIndex = index;
                        } else {
                          selectedIndex = -1;
                        }
                      });
                    },
                    child: Text(
                      courses[index].courseName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.blue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                        '${courses[index].teacher.firstName} ${courses[index].teacher.lastName}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.blueAccent,
                            fontSize: 19,
                            fontWeight: FontWeight.w300))),
                const SizedBox(
                  height: 8,
                ),
                Text(courses[index].courseDetails,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w200)),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 40),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: Text('Check Info',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))
              ],
            ),
          ),
        )
      ],
    );
  }

  Row _rowMethod(
      List<Course> courses, int index, BuildContext context, Color mycolor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            courses[index].image,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (selectedIndex != index) {
                          selectedIndex = index;
                        } else {
                          selectedIndex = -1;
                        }
                      });
                    },
                    child: Text(
                      courses[index].courseName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.blue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                        '${courses[index].teacher.firstName} ${courses[index].teacher.lastName}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.blueAccent,
                            fontSize: 19,
                            fontWeight: FontWeight.w300))),
                const SizedBox(
                  height: 8,
                ),
                Text(courses[index].courseDetails,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w200)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
