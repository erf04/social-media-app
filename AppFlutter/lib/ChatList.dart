import 'package:flutter/material.dart';

import 'package:flutter_application_2/gen/assets.gen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int selectedIndex = -1;
  //final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    List<String> chatNames = [
      'chat1',
      'chat2',
      'chat3',
      'chat4',
      'chat5',
      'chat6',
      'chat7'
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Assets.download.image(width: 40, height: 40)),
              const SizedBox(
                width: 12,
              ),
              Text(
                "LeadLearn",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: chatNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Assets.img.posts.small.smallPost1
                                    .image(width: 40, height: 40)),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              chatNames[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38),
                            )
                          ],
                        )),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
