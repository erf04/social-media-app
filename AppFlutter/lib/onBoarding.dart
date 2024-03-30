import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/home.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final items = AppDatabase.onBoardingItems;
  final PageController _pageController = PageController();
  int page = 0;
  @override
  void initState() {
    _pageController.addListener(() {
      if (_pageController.page!.round() != page) {
        setState(() {
          page = _pageController.page!.round();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: Assets.img.background.onboarding.image(),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 20)],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: PageView.builder(
                              itemCount: items.length,
                              controller: _pageController,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      items[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                    ),
                                    Text(
                                      items[index].description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                    ),
                                  ],
                                );
                              })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: items.length,
                            effect: const ExpandingDotsEffect(
                                activeDotColor: Colors.blue,
                                dotColor: Colors.grey),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (page == items.length - 1) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainPage()));
                              } else {
                                _pageController.animateToPage(page + 1,
                                    duration: const Duration(microseconds: 500),
                                    curve: Curves.decelerate);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 45),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Icon(
                              page != items.length - 1
                                  ? CupertinoIcons.arrow_right
                                  : CupertinoIcons.check_mark,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
