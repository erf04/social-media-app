// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_2/ChatList.dart';
// import 'package:flutter_application_2/data.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_application_2/gen/assets.gen.dart';
// import 'package:flutter_application_2/home.dart';
// import 'package:flutter_application_2/loginSignUp.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreen();
// }

// class _ChatScreen extends State<ChatScreen> {
//   String myIp = HttpClient.instance.options.baseUrl;
//   bool signup = false;
//   Color myColor = Colors.white.withOpacity(0.5);

//   final PageController _pageController = PageController();
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   _pageController.animateToPage(1,
//                       duration: const Duration(microseconds: 500),
//                       curve: Curves.decelerate);
//                 },
//                 child: const Icon(
//                   CupertinoIcons.arrow_left,
//                   size: 30,
//                 ),
//               ),
//               ClipRRect(
//                   borderRadius: BorderRadius.circular(32),
//                   child: Assets.download.image(width: 40, height: 40)),
//               const SizedBox(
//                 width: 15,
//               ),
//               Text(
//                 "LeadLearn",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleLarge!
//                     .copyWith(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Row(
//           children: [],
//         ),
//       ),
//     );
//   }
// }
