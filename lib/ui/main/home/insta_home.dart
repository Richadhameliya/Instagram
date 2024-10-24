import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/constant/app_assets.dart';
import 'package:instagram_app/controller/home_controller.dart';
import 'package:instagram_app/controller/story_controller.dart';
import '../../../constant/app_string.dart';
import '../comments/comment.dart';
import 'view_story.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final StoryController storyController = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Row(
                  children: [
                    assetImage(
                      AppAssets.instaTxt,
                      width: width * 0.3,
                    ),
                    const Icon(Icons.keyboard_arrow_down_outlined),
                    const Spacer(),
                    const Icon(Icons.favorite_border),
                    SizedBox(width: width * 0.02),
                    const Icon(Icons.message_outlined),
                  ],
                ),
              ),
              // Stories Section
              SizedBox(
                height: height * 0.14,
                child: Stack(
                  children: [
                    // List of stories
                    Obx(() {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1 +
                            controller.followedUserStories
                                .length, // User's story + followed users' stories
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.userStoryUrls.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewStory(
                                              controller.userStoryUrls
                                                  .toList()),
                                        ),
                                      );
                                    } else {
                                      storyController.pickImage();
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.03),
                                    child: CircleAvatar(
                                      radius: height * 0.05,
                                      backgroundColor: Colors.grey,
                                      child: CachedNetworkImage(
                                        imageUrl: controller.userProfileImageUrl
                                                .value.isNotEmpty
                                            ? controller
                                                .userProfileImageUrl.value
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
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.03),
                                  child: Text(AppString.yourStory),
                                ),
                              ],
                            );
                          } else {
                            final followedUserStory =
                                controller.followedUserStories[index - 1];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewStory(
                                            followedUserStory['storyUrls']),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.03),
                                    child: CircleAvatar(
                                      radius: height * 0.05,
                                      backgroundColor: Colors.grey,
                                      child: CachedNetworkImage(
                                        imageUrl: followedUserStory[
                                                'profileImageUrl'] ??
                                            'https://via.placeholder.com/150',
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
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.04),
                                  child: Text(followedUserStory['username']),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }),
                    // Positioned Add Button
                    Positioned(
                      bottom: 33,
                      left: 73,
                      child: GestureDetector(
                        onTap: () {
                          storyController
                              .pickImage(); // Allow user to pick image
                        },
                        child: Container(
                          height: height * 0.025,
                          width: height * 0.025,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Posts Section
              Obx(
                () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    final postId = post['uid'];
                    final lastComment = controller.comments[postId];
                    return Container(
                      height: height * 0.53,
                      width: width * 0.9,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: height * 0.02),
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
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                image: NetworkImage(post['mediaUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => CommentScreen(
                                    //         postId: post[
                                    //             'uid']), // Assuming post has an 'id'
                                    //   ),
                                    // );
                                    print("////////////////////${post['uid']}");
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) => CommentScreen(
                                        postId: post['uid'],
                                      ),
                                    );
                                  },
                                  child:
                                      const Icon(Icons.mode_comment_outlined),
                                ),
                                SizedBox(width: width * 0.03),
                                const Icon(Icons.send_outlined),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    controller.toggleBookmark(index);
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
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: Text("hello"),
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: height * 0.02,
                                vertical: width * 0.02),
                            child: lastComment != null
                                ? Text(
                                    '${lastComment['username']}  ${lastComment['comment']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : Text(
                                    AppString.noCommentYet,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
