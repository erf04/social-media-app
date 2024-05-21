import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/ChatList.dart';
import 'package:flutter_application_2/SharedPreferencesFile.dart';
import 'package:flutter_application_2/chat.dart';
import 'package:flutter_application_2/coursePage.dart';
import 'package:flutter_application_2/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/home.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/profile.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0D253C);
    const secondryTextColor = Color(0xff2D4379);
    return MaterialApp(
      title: 'Lead Learn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primaryTextColor,
                fontFamily: 'avenir'),
            titleLarge: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontFamily: 'avenir'),
            bodySmall: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w300,
              color: secondryTextColor,
              fontFamily: 'avenir',
            )),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: AuthScreen(),
      //const SplashScreen(),
      // home: Stack(children: [
      //   const Positioned.fill(child: MainPage()),
      //   Positioned(bottom: 0, left: 0, right: 0, child: _BottomNavigation())
      // ]),
      // );
      //}
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Stack(children: [
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            height: 70,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Image.asset('assets/img/icons/Home.png'),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'home',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blueAccent),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Image.asset('assets/img/icons/Articles.png'),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'lessons',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blueAccent),
                    )
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Image.asset('assets/img/icons/Search.png'),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'search',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blueAccent),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Image.asset('assets/img/icons/Menu.png'),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'settings',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blueAccent),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Color(0xff0D253C), blurRadius: 10)
                    ],
                    borderRadius: BorderRadius.circular(32.5),
                    color: Colors.blueAccent),
                child: const Icon(
                  CupertinoIcons.plus,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          ),
        )
      ]),
    );
  }
}
