import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = AppDatabase.stories;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi Amirreza',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Image.asset(
                      'assets/img/icons/notification.png',
                      width: 28,
                      height: 28,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                child: Text(
                  'New Lessons Available!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 7),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  child: ListView.builder(
                      itemCount: stories.length + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox(width: 20);
                        }
                        return Container(
                          margin: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  stories[index - 1].isViewed
                                      ? storyImageSeen(stories, index)
                                      : storyImageNotSeen(stories, index),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Image.asset(
                                      'assets/img/icons/${stories[index - 1].iconFileName}',
                                      width: 30,
                                      height: 30,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 0,
                                height: 8,
                              ),
                              Center(
                                  child: stories[index - 1].name.length <= 7
                                      ? Text(stories[index - 1].name)
                                      : Text(AppDatabase.limiter(
                                          stories[index - 1].name))),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              const DoList(),
              const Divider(
                color: Colors.black,
              ),
              LatestNews(),
            ],
          ),
        ),
      ),
    );
  }

  Widget storyImageNotSeen(List<StoryData> stories, int index) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              colors: [Colors.red, Colors.blue, Colors.grey])),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
                'assets/img/stories/${stories[index - 1].imageFileName}'),
          ),
        ),
      ),
    );
  }

  Widget storyImageSeen(List<StoryData> stories, int index) {
    return SizedBox(
      width: 85,
      height: 85,
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        radius: const Radius.circular(20),
        dashPattern: const [10, 4, 4, 3],
        color: Colors.redAccent,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    colors: [Colors.red, Colors.blue, Colors.grey])),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                      'assets/img/stories/${stories[index - 1].imageFileName}'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoList extends StatelessWidget {
  const DoList({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var categories = AppDatabase.categories;
    return CarouselSlider.builder(
        itemCount: categories.length,
        itemBuilder: (context, index, realIndex) {
          return _silder(category: categories[index]);
        },
        options: CarouselOptions(
            viewportFraction: 0.8,
            scrollDirection: Axis.horizontal,
            aspectRatio: 1.2,
            disableCenter: false,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlay: true,
            enableInfiniteScroll: true));
  }
}

class LatestNews extends StatelessWidget {
  final posts = AppDatabase.posts;
  LatestNews({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 72),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest News:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'More',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.blue),
                  ))
            ],
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: posts.length,
                itemExtent: 150,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/img/posts/small/${post.imageFileName}',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.caption,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.blueAccent),
                              ),
                              Text(post.title,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.heart),
                                  Text(post.likes),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(CupertinoIcons.clock),
                                  Text(post.time),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: post.isBookmarked
                                              ? const Icon(
                                                  CupertinoIcons.bookmark_fill)
                                              : const Icon(
                                                  CupertinoIcons.bookmark)))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class _silder extends StatelessWidget {
  const _silder({
    super.key,
    required this.category,
  });
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        margin: const EdgeInsets.all(3),
        foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Color(0xff0D253C), Colors.transparent])),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset('assets/img/posts/large/${category.imageFileName}',
              fit: BoxFit.cover),
        ),
      ),
      Positioned(
          right: 60,
          bottom: 42,
          child: Text(
            category.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white70),
          ))
    ]);
  }
}
