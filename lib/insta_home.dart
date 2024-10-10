// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controller/home_controller.dart';
//
// class HomePage extends StatelessWidget {
//   final HomeController controller = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       'assets/images/insta_txt.png',
//                       scale: 3.5,
//                     ),
//                     Icon(Icons.keyboard_arrow_down_outlined),
//                     Spacer(),
//                     Icon(Icons.favorite_border),
//                     SizedBox(width: width * 0.02),
//                     Icon(Icons.message_outlined),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.15,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 8,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         Row(
//                           children: [
//                             index == 0
//                                 ? Stack(
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       Obx(() => GestureDetector(
//                                             onTap: () {},
//                                             child: Container(
//                                               height: height * 0.1,
//                                               width: height * 0.1,
//                                               margin: EdgeInsets.only(
//                                                   left: width * 0.04),
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.grey,
//                                               ),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: controller
//                                                             .userProfileImageUrl
//                                                             .value !=
//                                                         ''
//                                                     ? controller
//                                                         .userProfileImageUrl
//                                                         .value
//                                                     : 'https://via.placeholder.com/150',
//                                                 imageBuilder:
//                                                     (context, imageProvider) =>
//                                                         Container(
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     image: DecorationImage(
//                                                       image: imageProvider,
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 placeholder: (context, url) =>
//                                                     Icon(
//                                                   Icons.camera_alt_outlined,
//                                                   color: Colors.white,
//                                                   size: 40,
//                                                 ),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         Icon(Icons.error),
//                                               ),
//                                             ),
//                                           )),
//                                       Positioned(
//                                         bottom: 2,
//                                         right: 1,
//                                         left: width * 0.18,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             controller.pickImage();
//                                           },
//                                           child: Container(
//                                             height: height * 0.03,
//                                             width: height * 0.03,
//                                             child: Icon(Icons.add,
//                                                 color: Colors.white),
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.blue,
//                                               border: Border.all(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(
//                                     height: height * 0.1,
//                                     width: height * 0.1,
//                                     margin: EdgeInsets.only(left: width * 0.04),
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey,
//                                         shape: BoxShape.circle),
//                                   ),
//                           ],
//                         ),
//                         index == 0
//                             ? Padding(
//                                 padding: const EdgeInsets.only(left: 8),
//                                 child: Text('Your story'),
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(left: 17),
//                                 child: Text('Username'),
//                               )
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Obx(() => ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: controller.posts.length,
//                     itemBuilder: (context, index) {
//                       final post = controller.posts[index];
//                       return Container(
//                         height: height * 0.51,
//                         width: width * 0.9,
//                         color: Colors.transparent,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: height * 0.015),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: height * 0.08,
//                                     height: height * 0.08,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.grey,
//                                     ),
//                                     child: CachedNetworkImage(
//                                       imageUrl: post['userProfileImageUrl'] !=
//                                               null
//                                           ? post['userProfileImageUrl']
//                                           : 'https://via.placeholder.com/150',
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       placeholder: (context, url) => Icon(
//                                         Icons.camera_alt_outlined,
//                                         color: Colors.white,
//                                         size: 40,
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                   SizedBox(width: width * 0.02),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(post['username'] ?? 'Username'),
//                                       Text('Location'),
//                                     ],
//                                   ),
//                                   Spacer(),
//                                   // Obx(() {
//                                   //   bool isFollowing =
//                                   //       controller.isFollowing(post['uid']);
//                                   //   return MaterialButton(
//                                   //     height: height * 0.04,
//                                   //     shape: OutlineInputBorder(
//                                   //       borderRadius: BorderRadius.circular(7),
//                                   //       borderSide: BorderSide.none,
//                                   //     ),
//                                   //     color: Colors.grey.shade300,
//                                   //     onPressed: () {
//                                   //       String postUserId = post['uid'];
//                                   //       controller.toggleFollow(postUserId);
//                                   //     },
//                                   //     child: Text(
//                                   //       isFollowing ? "Following" : "Follow",
//                                   //       style: TextStyle(fontSize: 15),
//                                   //     ),
//                                   //   );
//                                   // }),
//                                   Icon(Icons.more_vert),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: height * 0.01),
//                             Container(
//                               height: height * 0.36,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(post['image']),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: height * 0.01),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       controller.toggleFavorite(index);
//                                     },
//                                     child: Obx(() => Icon(
//                                           controller.favorites[index]
//                                               ? Icons.favorite
//                                               : Icons.favorite_border,
//                                           color: controller.favorites[index]
//                                               ? Colors.red
//                                               : Colors.black,
//                                         )),
//                                   ),
//                                   SizedBox(width: width * 0.03),
//                                   Icon(Icons.mode_comment_outlined),
//                                   SizedBox(width: width * 0.03),
//                                   Icon(Icons.send_outlined),
//                                   Spacer(),
//                                   Icon(Icons.bookmark_border),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/insta_txt.png',
                      scale: 3.5,
                    ),
                    const Icon(Icons.keyboard_arrow_down_outlined),
                    const Spacer(),
                    const Icon(Icons.favorite_border),
                    SizedBox(width: width * 0.02),
                    const Icon(Icons.message_outlined),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            index == 0
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Obx(() => GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MoreStories()));
                                              // // Show the story when tapped
                                              // showStoryDialog(
                                              //     context,
                                              //     controller.userProfileImageUrl
                                              //         .value);
                                            },
                                            child: Container(
                                              height: height * 0.1,
                                              width: height * 0.1,
                                              margin: EdgeInsets.only(
                                                  left: width * 0.04),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: controller
                                                        .storyUrls.isNotEmpty
                                                    ? Border.all(
                                                        color: Colors.blue,
                                                        width: 4)
                                                    : null,
                                                color: Colors.grey,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: controller
                                                        .userProfileImageUrl
                                                        .value
                                                        .isNotEmpty
                                                    ? controller
                                                        .userProfileImageUrl
                                                        .value
                                                    : 'https://via.placeholder.com/150',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                        bottom: 2,
                                        right: 1,
                                        left: width * 0.18,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.pickImage();
                                          },
                                          child: Container(
                                            height: height * 0.03,
                                            width: height * 0.03,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: const Icon(Icons.add,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: height * 0.1,
                                    width: height * 0.1,
                                    margin: EdgeInsets.only(left: width * 0.04),
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                  ),
                          ],
                        ),
                        index == 0
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text('Your story'),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(left: 17),
                                child: Text('Username'),
                              )
                      ],
                    );
                  },
                ),
              ),
              Obx(() => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.posts.length,
                    itemBuilder: (context, index) {
                      final post = controller.posts[index];
                      return Container(
                        height: height * 0.51,
                        width: width * 0.9,
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.015),
                              child: Row(
                                children: [
                                  Container(
                                    width: height * 0.08,
                                    height: height * 0.08,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: post['userProfileImageUrl'] ??
                                          'https://via.placeholder.com/150',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(post['username'] ?? 'Username'),
                                      const Text('Location'),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.more_vert),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Container(
                              height: height * 0.36,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(post['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.toggleFavorite(index);
                                    },
                                    child: Obx(() => Icon(
                                          controller.favorites[index]
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: controller.favorites[index]
                                              ? Colors.red
                                              : Colors.black,
                                        )),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  const Icon(Icons.mode_comment_outlined),
                                  SizedBox(width: width * 0.03),
                                  const Icon(Icons.send_outlined),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      controller.toggleBookmark(
                                          index); // Handle bookmark toggle
                                    },
                                    child: Obx(
                                      () => Icon(
                                        controller.saved[index]
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: controller.saved[index]
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

//   // Function to show the story dialog
//   void showStoryDialog(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Container(
//           width: double.maxFinite,
//           height: MediaQuery.of(context).size.height * 0.8,
//           child: Image.network(imageUrl, fit: BoxFit.cover),
//         ),
//         actions: [
//           TextButton(
//             child: Text("Close"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (homeController.storyUrls.isEmpty) {
          return Center(child: Text("No stories available"));
        }

        return StoryView(
          storyItems: homeController.storyUrls.map((url) {
            return StoryItem.pageImage(
              url: url,
              caption: Text(
                "",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              controller: StoryController(),
            );
          }).toList(),
          onStoryShow: (storyItem, index) {
            print("Showing story $index");
          },
          onComplete: () {
            print("Completed a cycle");
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
          controller: StoryController(),
        );
      }),
    );
  }
}
