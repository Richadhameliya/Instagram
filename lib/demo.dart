import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  var userStoryUrls = <String>[].obs;

  Future<void> fetchFollowingUserStories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the user document to get the following list
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('following') &&
            userData['following'] is List) {
          List<String> followingList = List<String>.from(userData['following']);
          List<String> fetchedStoryUrls = [];

          for (String followingId in followingList) {
            DocumentSnapshot followingUserSnapshot = await FirebaseFirestore
                .instance
                .collection('InstaUser')
                .doc(followingId)
                .get();

            if (followingUserSnapshot.exists) {
              final followingUserData =
                  followingUserSnapshot.data() as Map<String, dynamic>;
              if (followingUserData.containsKey('stories') &&
                  followingUserData['stories'] != null) {
                final List<dynamic> stories =
                    List<dynamic>.from(followingUserData['stories']);
                for (var story in stories) {
                  fetchedStoryUrls.add(story['url'].toString());
                }
              }
            }
          }
          userStoryUrls.value = fetchedStoryUrls;
        } else {
          userStoryUrls.value = [];
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFollowingUserStories(); // Fetch stories when initialized
  }
}

class StoriesScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
      ),
      body: Obx(() {
        if (controller.userStoryUrls.isEmpty) {
          return Center(child: Text('No stories available.'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.userStoryUrls.length, (index) {
              return GestureDetector(
                onTap: () {
                  _showStoryDialog(context, controller.userStoryUrls[index]);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(controller.userStoryUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  void _showStoryDialog(BuildContext context, String storyUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Image.network(storyUrl, fit: BoxFit.cover),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: StoriesScreen(),
  ));
}
