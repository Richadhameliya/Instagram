import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'controller/home_controller.dart'; // Import cached network image

class SavedPostsPage extends StatelessWidget {
  SavedPostsPage({Key? key}) : super(key: key);

  final HomeController controller = Get.find(); // Access HomeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
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
              child: Text('No saved posts yet'),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            controller.posts[index]['userProfileImageUrl'] ??
                                'https://via.placeholder.com/150',
                          ),
                        ),
                        SizedBox(width: 10),
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
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(controller.posts[index]['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add some space after each post
                ],
              );
            },
          );
        },
      ),
    );
  }
}
