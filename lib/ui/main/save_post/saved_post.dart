import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_app/controller/home_controller.dart';

import '../../../constant/app_string.dart';

class SavedPostsPage extends StatelessWidget {
  SavedPostsPage({Key? key}) : super(key: key);

  final HomeController controller = Get.find(); // Access HomeController

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.savedPost),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(
        () {
          if (controller.userBookmarks.isEmpty) {
            return Center(
              child: Text(AppString.noSavePost),
            );
          }

          return ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              // Filter only saved posts
              String postId = controller.posts[index]['uid'];
              if (!controller.userBookmarks.contains(postId)) {
                return SizedBox.shrink(); // Skip if post is not saved
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            controller.posts[index]['userProfileImageUrl'] ??
                                'https://via.placeholder.com/150',
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          controller.posts[index]['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage(controller.posts[index]['mediaUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.02), // Add some space after each post
                ],
              );
            },
          );
        },
      ),
    );
  }
}
