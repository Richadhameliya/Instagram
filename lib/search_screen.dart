// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controller/search_controller.dart';
//
// class InstaSearchScreen extends StatelessWidget {
//   final SearchScreenController searchController =
//       Get.put(SearchScreenController());
//   final TextEditingController searchFieldController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               TextField(
//                 controller: searchFieldController,
//                 focusNode: _focusNode,
//                 decoration: InputDecoration(
//                   hintText: 'Search user by username',
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   searchController.searchUsers(value);
//                 },
//                 onTap: () {
//                   searchController.hideImages();
//                 },
//               ),
//               Obx(
//                 () {
//                   if (searchController.isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (searchController.searchResults.isEmpty &&
//                       searchFieldController.text.isNotEmpty) {
//                     return const Center(child: Text('No users found'));
//                   } else if (searchFieldController.text.isNotEmpty) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: searchController.searchResults.length,
//                       itemBuilder: (context, index) {
//                         final user = searchController.searchResults[index];
//
//                         return ListTile(
//                           leading: user['profileImageUrl'] != null
//                               ? CircleAvatar(
//                                   backgroundImage:
//                                       NetworkImage(user['profileImageUrl']),
//                                 )
//                               : const CircleAvatar(
//                                   child: Icon(Icons.person),
//                                 ),
//                           title: Text(user['username']),
//                           subtitle: Text(user['email']),
//                           trailing: Obx(() {
//                             bool isFollowing =
//                                 searchController.isFollowing(user['uid']);
//                             return MaterialButton(
//                               height: screenHeight * 0.04,
//                               shape: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(7),
//                                 borderSide: BorderSide.none,
//                               ),
//                               color: Colors.grey.shade300,
//                               onPressed: () {
//                                 String postUserId = user['uid'];
//                                 searchController.toggleFollow(postUserId);
//                               },
//                               child: Text(
//                                 isFollowing ? "Following" : "Follow",
//                                 style: TextStyle(fontSize: 15),
//                               ),
//                             );
//                           }),
//                           // trailing: FutureBuilder<bool>(
//                           //   future: searchController.isFollowing(user['uid']),
//                           //   builder: (context, snapshot) {
//                           //     if (snapshot.connectionState ==
//                           //         ConnectionState.waiting) {
//                           //       return CircularProgressIndicator(); // or a placeholder
//                           //     }
//                           //     final isFollowing = snapshot.data ?? false;
//                           //     return MaterialButton(
//                           //       height: screenHeight * 0.03,
//                           //       color: Colors.grey.shade300,
//                           //       shape: OutlineInputBorder(
//                           //           borderSide: BorderSide.none,
//                           //           borderRadius: BorderRadius.circular(7)),
//                           //       onPressed: () {
//                           //         searchController.toggleFollow(user['uid']);
//                           //       },
//                           //       child: Text(
//                           //         isFollowing ? "Following" : "Follow",
//                           //         style: TextStyle(fontSize: 15),
//                           //       ),
//                           //     );
//                           //   },
//                           // ),
//                         );
//                       },
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//               SizedBox(height: 5),
//               Obx(() {
//                 if (_focusNode.hasFocus ||
//                     searchFieldController.text.isNotEmpty) {
//                   return SizedBox.shrink();
//                 } else if (searchController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (searchController.allImages.isEmpty) {
//                   return const Center(child: Text('No images available.'));
//                 } else {
//                   return Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 4.0,
//                           mainAxisSpacing: 4.0,
//                         ),
//                         itemCount: searchController.allImages.length,
//                         itemBuilder: (context, index) {
//                           final imageUrl = searchController.allImages[index];
//
//                           return imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Container(
//                                   color: Colors.grey.shade100,
//                                 );
//                         },
//                       ),
//                     ),
//                   );
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/search_controller.dart';

class InstaSearchScreen extends StatelessWidget {
  final SearchScreenController searchController =
      Get.put(SearchScreenController());
  final TextEditingController searchFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: searchFieldController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search....',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  searchController.searchUsers(value);
                },
                onTap: () {
                  searchController.hideImages();
                },
              ),
              Obx(
                () {
                  if (searchController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (searchController.searchResults.isEmpty &&
                      searchFieldController.text.isNotEmpty) {
                    return const Center(child: Text('No users found'));
                  } else if (searchFieldController.text.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchController.searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchController.searchResults[index];
                        final currentUser = FirebaseAuth.instance.currentUser;

                        return ListTile(
                          leading: user['profileImageUrl'] != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user['profileImageUrl']),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Text(user['username']),
                          subtitle: Text(user['email']),
                          trailing: currentUser?.uid != user['uid']
                              ? Obx(() {
                                  bool isFollowing =
                                      searchController.isFollowing(user['uid']);
                                  return MaterialButton(
                                    height: screenHeight * 0.04,
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide.none,
                                    ),
                                    color: Colors.grey.shade300,
                                    onPressed: () {
                                      String postUserId = user['uid'];
                                      searchController.toggleFollow(postUserId);
                                    },
                                    child: Text(
                                      isFollowing ? "Following" : "Follow",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                })
                              : IconButton(
                                  icon: Icon(Icons.person),
                                  onPressed: () {
                                    // Navigate to the profile screen
                                    Get.toNamed('/profile',
                                        arguments: user['uid']);
                                  },
                                ),
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 5),
              Obx(() {
                if (_focusNode.hasFocus ||
                    searchFieldController.text.isNotEmpty) {
                  return SizedBox.shrink();
                } else if (searchController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (searchController.allImages.isEmpty) {
                  return const Center(child: Text('No images available.'));
                } else {
                  return Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: searchController.allImages.length,
                        itemBuilder: (context, index) {
                          final imageUrl = searchController.allImages[index];

                          return imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey.shade100,
                                );
                        },
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
