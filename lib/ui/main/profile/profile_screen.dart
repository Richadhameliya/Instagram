import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram_app/ui/main/reels/rells_screen.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_string.dart';
import '../../../controller/profile_controller.dart';
import '../../../controller/search_controller.dart';
import '../../auth/log_out_screen.dart';
import 'Edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user.uid)
          .get();

      setState(() {
        posts = snapshot.docs.map((doc) {
          return {'image': doc['mediaUrl'], 'uid': doc['uid']};
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final SearchScreenController searchController =
        Get.put(SearchScreenController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
              ChangeNotifierProvider(
                create: (_) => UserController(),
                child: Consumer<UserController>(
                  builder: (context, userController, child) {
                    if (userController.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var userData = userController.userData;
                    String email = userData['email'];
                    String username = userData['username'];
                    String? profileImageUrl = userData['imageUrl'];

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lock_outline, size: 17),
                                  Text(' $email',
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 5),
                                  Icon(Icons.keyboard_arrow_down_sharp,
                                      size: 17),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogOutScreen(),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.menu, size: 25),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profileImageUrl ?? '',
                                          placeholder: (context, url) =>
                                              Container(
                                            width: screenWidth *
                                                0.26, // Circle diameter
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: screenWidth * 0.26,
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.person,
                                                size: screenWidth *
                                                    0.08), // Placeholder icon
                                          ),
                                          width: screenWidth * 0.26,
                                          height: screenWidth * 0.26,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 4,
                                        child: Container(
                                          height: screenHeight * 0.05,
                                          width: screenWidth * 0.05,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                      Positioned(
                                        left: 19,
                                        top: -20,
                                        child: Container(
                                          height: screenHeight * 0.05,
                                          width: screenWidth * 0.17,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppString.current,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                AppString.vibe,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(children: [
                                    Text(
                                      '${userController.posts.length}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(AppString.posts)
                                  ]),
                                  Spacer(),
                                  Column(
                                    children: [
                                      //Text('0'),
                                      Obx(() {
                                        int followersCount =
                                            searchController.followers.length;
                                        return Text(
                                          '$followersCount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        );
                                      }),

                                      Text(AppString.followers),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Obx(
                                        () {
                                          int followingCount = searchController
                                              .followingUsers.length;
                                          return Text(
                                            '$followingCount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          );
                                        },
                                      ),
                                      // Text("0"),
                                      Text(AppString.following),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(username,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(),
                                          ));
                                    },
                                    child: Container(
                                      height: screenHeight * 0.040,
                                      width: screenWidth * 0.41,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          AppString.editProfile,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: screenHeight * 0.040,
                                      width: screenWidth * 0.41,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '${AppString.shareProfile}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: screenHeight * 0.040,
                                      width: screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.person_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.07,
                                    width: screenHeight * 0.07,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade600),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                  Text(AppString.newTxt),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // DefaultTabController(
                        //   length: 3,
                        //   child: Column(
                        //     children: [
                        //       TabBar(
                        //         indicatorColor: Colors.blue,
                        //         indicatorSize: TabBarIndicatorSize.tab,
                        //         dividerColor: Colors.transparent,
                        //         labelColor: Colors.blue,
                        //         tabs: [
                        //           Tab(icon: Icon(Icons.grid_on)),
                        //           Tab(icon: Icon(Icons.video_collection)),
                        //           Tab(icon: Icon(Icons.person_pin)),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: screenHeight * 0.3,
                        //         child: TabBarView(
                        //           children: [
                        //             // Posts Tab
                        //
                        //             userController.posts.isEmpty
                        //                 ? Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     children: [
                        //                       Container(
                        //                         height: screenHeight * 0.09,
                        //                         width: screenWidth * 0.3,
                        //                         decoration: BoxDecoration(
                        //                             shape: BoxShape.circle,
                        //                             border: Border.all(
                        //                                 color: Colors.black)),
                        //                         child: Icon(
                        //                           CupertinoIcons.photo_camera,
                        //                           color: Colors.black,
                        //                           size: 36,
                        //                         ),
                        //                       ),
                        //                       SizedBox(
                        //                         height: screenHeight * 0.01,
                        //                       ),
                        //                       Center(
                        //                         child: Text(
                        //                           AppString.noPostYet,
                        //                           style: TextStyle(
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                               fontSize: 21),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   )
                        //                 : GridView.builder(
                        //                     gridDelegate:
                        //                         SliverGridDelegateWithFixedCrossAxisCount(
                        //                       crossAxisCount: 3,
                        //                       crossAxisSpacing: 4.0,
                        //                       mainAxisSpacing: 4.0,
                        //                     ),
                        //                     itemCount:
                        //                         userController.posts.length,
                        //                     shrinkWrap:
                        //                         true, // Important for proper sizing
                        //                     physics:
                        //                         NeverScrollableScrollPhysics(),
                        //                     itemBuilder: (context, index) {
                        //                       final post =
                        //                           userController.posts[index];
                        //                       return ClipRRect(
                        //                         borderRadius:
                        //                             BorderRadius.circular(8),
                        //                         child: CachedNetworkImage(
                        //                           imageUrl: post['mediaUrl'],
                        //                           placeholder: (context, url) =>
                        //                               Container(
                        //                             color: Colors.grey[200],
                        //                           ),
                        //                           errorWidget:
                        //                               (context, url, error) =>
                        //                                   Container(
                        //                             color: Colors.grey[200],
                        //                             child: Icon(Icons.error,
                        //                                 color: Colors.red),
                        //                           ),
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       );
                        //                     },
                        //                   ),
                        //             //Reels Tab
                        //             GridView.builder(
                        //               gridDelegate:
                        //                   SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 3,
                        //                 mainAxisSpacing: 4.0,
                        //                 crossAxisSpacing: 4.0,
                        //                 childAspectRatio: 0.51,
                        //               ),
                        //               itemCount: userController.reels.length,
                        //               itemBuilder: (context, index) {
                        //                 final reel =
                        //                     userController.reels[index];
                        //                 return ClipRRect(
                        //                   borderRadius:
                        //                       BorderRadius.circular(8),
                        //                   child: Container(
                        //                     color: Colors.black,
                        //                     child: Stack(
                        //                       children: [
                        //                         Positioned.fill(
                        //                           child: VideoPlayerWidget(
                        //                               videoUrl:
                        //                                   reel['mediaUrl']),
                        //                         ),
                        //                         Positioned(
                        //                           bottom: 10,
                        //                           // right: 10,
                        //                           child: Icon(
                        //                             Icons.play_arrow_outlined,
                        //                             color: Colors.white,
                        //                             size: 25,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //             // Tagged Tab
                        //             Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Container(
                        //                   height: screenHeight * 0.09,
                        //                   width: screenHeight * 0.09,
                        //                   decoration: BoxDecoration(
                        //                       shape: BoxShape.circle,
                        //                       border: Border.all(
                        //                           color: Colors.black)),
                        //                   child: Icon(
                        //                     Icons.person_pin_outlined,
                        //                     size: 40,
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: screenHeight * 0.016,
                        //                 ),
                        //                 Center(
                        //                     child: Text(
                        //                   AppString.photosAndVideosOfYou,
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 21),
                        //                 )),
                        //                 SizedBox(
                        //                   height: screenHeight * 0.016,
                        //                 ),
                        //                 Center(
                        //                     child: Text(
                        //                   AppString.profileTagTxt,
                        //                   style: TextStyle(
                        //                       fontSize: 15, color: Colors.grey),
                        //                 )),
                        //                 Center(
                        //                     child: Text(
                        //                   AppString.appearHere,
                        //                   style: TextStyle(
                        //                       fontSize: 15, color: Colors.grey),
                        //                 )),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        DefaultTabController(
                          length: userController.reels.isNotEmpty ? 3 : 2,
                          child: Column(
                            children: [
                              TabBar(
                                indicatorColor: Colors.blue,
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: Colors.blue,
                                tabs: [
                                  Tab(icon: Icon(Icons.grid_on)), // Posts Tab
                                  if (userController.reels
                                      .isNotEmpty) // Conditional Reels Tab
                                    Tab(icon: Icon(Icons.video_collection)),
                                  Tab(
                                      icon:
                                          Icon(Icons.person_pin)), // Tagged Tab
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.3,
                                child: TabBarView(
                                  children: [
                                    // Posts Tab
                                    userController.posts.isEmpty
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: screenHeight * 0.09,
                                                width: screenWidth * 0.3,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.photo_camera,
                                                  color: Colors.black,
                                                  size: 36,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              Center(
                                                child: Text(
                                                  AppString.noPostYet,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 4.0,
                                            ),
                                            itemCount:
                                                userController.posts.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final post =
                                                  userController.posts[index];
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: post['mediaUrl'],
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: Colors.grey[200],
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.grey[200],
                                                    child: Icon(Icons.error,
                                                        color: Colors.red),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          ),
                                    // Reels Tab (only if reels exist)
                                    if (userController.reels.isNotEmpty)
                                      GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 4.0,
                                          crossAxisSpacing: 4.0,
                                          childAspectRatio: 0.51,
                                        ),
                                        itemCount: userController.reels.length,
                                        itemBuilder: (context, index) {
                                          final reel =
                                              userController.reels[index];
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              color: Colors.black,
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: VideoPlayerWidget(
                                                        videoUrl:
                                                            reel['mediaUrl']),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    child: Icon(
                                                      Icons.play_arrow_outlined,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    // Tagged Tab
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: screenHeight * 0.09,
                                          width: screenHeight * 0.09,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Icon(
                                            Icons.person_pin_outlined,
                                            size: 40,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.016),
                                        Center(
                                          child: Text(
                                            AppString.photosAndVideosOfYou,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 21,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.016),
                                        Center(
                                          child: Text(
                                            AppString.profileTagTxt,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            AppString.appearHere,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
