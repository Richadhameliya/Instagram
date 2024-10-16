// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:instagram_app/profile_screen.dart';
// import 'package:instagram_app/search_screen.dart';
// import 'add_post_screen.dart';
// import 'controller/home_controller.dart';
// import 'insta_home.dart';
// import 'rells_screen.dart';
//
// class BottomNavBar extends StatefulWidget {
//   BottomNavBar({super.key});
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// final HomeController controller = Get.put(HomeController());
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   List screenname = [
//     HomePage(),
//     InstaSearchScreen(),
//     AddPostScreen(),
//     RellsScreenInsta(),
//     ProfileScreen(),
//   ];
//   int selectedScreen = 0;
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         // backgroundColor: Colors.black,
//         selectedItemColor: Colors.black,
//         selectedIconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         elevation: 2,
//         type: BottomNavigationBarType.fixed,
//         unselectedItemColor: Colors.grey,
//         currentIndex: selectedScreen,
//         items: [
//           const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home_filled,
//                 // color: Color(0xffFF897E),
//                 size: 30,
//               ),
//               label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.search,
//                 size: 30,
//               ),
//               label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.add_box_outlined,
//                 size: 30,
//               ),
//               label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.smart_display_outlined,
//                 size: 30,
//               ),
//               label: ""),
//           BottomNavigationBarItem(
//               icon: CircleAvatar(
//                 radius: height * 0.02,
//                 backgroundColor: Colors.grey,
//                 child: CachedNetworkImage(
//                   imageUrl: controller.userProfileImageUrl.value.isNotEmpty
//                       ? controller.userProfileImageUrl.value
//                       : 'https://via.placeholder.com/150',
//                   imageBuilder: (context, imageProvider) => Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   placeholder: (context, url) =>
//                       const CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//               label: ""),
//         ],
//         onTap: (value) {
//           selectedScreen = value;
//           setState(() {});
//         },
//       ),
//       body: screenname[selectedScreen],
//     );
//   }
// }

// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:instagram_app/profile_screen.dart';
// import 'package:instagram_app/search_screen.dart';
// import 'controller/home_controller.dart';
// import 'controller/post_controller.dart';
// import 'insta_home.dart';
// import 'rells_screen.dart';
// import 'package:image_picker/image_picker.dart';
//
// class BottomNavBar extends StatefulWidget {
//   BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// final HomeController controller = Get.put(HomeController());
// final AddPostController addPostController = Get.put(AddPostController());
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   List<Widget> screenname = [
//     HomePage(),
//     InstaSearchScreen(),
//     Container(), // Placeholder for Add button action
//     RellsScreenInsta(),
//     ProfileScreen(),
//   ];
//
//   int selectedScreen = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.black,
//         selectedIconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         elevation: 2,
//         type: BottomNavigationBarType.fixed,
//         unselectedItemColor: Colors.grey,
//         currentIndex: selectedScreen,
//         items: [
//           const BottomNavigationBarItem(
//               icon: Icon(Icons.home_filled, size: 30), label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(Icons.search, size: 30), label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
//           const BottomNavigationBarItem(
//               icon: Icon(Icons.smart_display_outlined, size: 30), label: ""),
//           BottomNavigationBarItem(
//               icon: CircleAvatar(
//                 radius: height * 0.02,
//                 backgroundColor: Colors.grey,
//                 child: CachedNetworkImage(
//                   imageUrl: controller.userProfileImageUrl.value.isNotEmpty
//                       ? controller.userProfileImageUrl.value
//                       : 'https://via.placeholder.com/150',
//                   imageBuilder: (context, imageProvider) => Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   placeholder: (context, url) =>
//                       const CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//               label: ""),
//         ],
//         onTap: (value) {
//           if (value == 2) {
//             // Open gallery to select an image or video
//             _pickMedia();
//           } else {
//             // Update selected screen for other tabs
//             setState(() {
//               selectedScreen = value;
//             });
//           }
//         },
//       ),
//       body: screenname[selectedScreen],
//     );
//   }
//
//   void _pickMedia() async {
//     final ImagePicker picker = ImagePicker();
//
//     // Picking image
//     final XFile? selectedImage =
//         await picker.pickImage(source: ImageSource.gallery);
//     if (selectedImage != null) {
//       await _uploadMedia(selectedImage);
//       return; // Exit after handling image
//     }
//
//     // Picking video
//     final XFile? selectedVideo =
//         await picker.pickVideo(source: ImageSource.gallery);
//     if (selectedVideo != null) {
//       await _uploadMedia(selectedVideo);
//     }
//   }
//
//   Future<void> _uploadMedia(XFile mediaFile) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         Fluttertoast.showToast(
//           msg: "User not authenticated",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//         return; // Exit if user is not authenticated
//       }
//
//       // Ensure mimeType is not null
//       String? mimeType = mediaFile.mimeType;
//
//       // Fallback if mimeType is null
//       if (mimeType == null) {
//         String fileExtension = mediaFile.path.split('.').last.toLowerCase();
//         mimeType = _getMimeType(fileExtension);
//         if (mimeType == null) {
//           Fluttertoast.showToast(
//             msg: "Unsupported file type",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//           return; // Exit if mime type is unsupported
//         }
//       }
//       DocumentSnapshot snapshot =
//           await _firestore.collection('InstaUser').doc(user.uid).get();
//
//       String username = snapshot.exists && snapshot.data() != null
//           ? (snapshot.data() as Map<String, dynamic>)['username'] ??
//               'Unknown User'
//           : 'Unknown User';
//
//       String userProfileImageUrl = snapshot.exists && snapshot.data() != null
//           ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
//           : '';
//
//       // Construct file path for upload
//       String filePath =
//           'media/${DateTime.now().millisecondsSinceEpoch}.$mimeType';
//       Reference ref = FirebaseStorage.instance.ref().child(filePath);
//
//       // Upload the file
//       await ref.putFile(File(mediaFile.path));
//
//       // Get download URL
//       String downloadUrl = await ref.getDownloadURL();
//
//       // Determine if the file is an image or video and save to the appropriate collection
//       if (mimeType.startsWith('image/')) {
//         // Save to 'posts' collection
//         await FirebaseFirestore.instance.collection('posts').add({
//           'mediaUrl': downloadUrl,
//           'uid': user.uid,
//           'timestamp': FieldValue.serverTimestamp(),
//           'username': username,
//           'userProfileImageUrl': userProfileImageUrl,
//         });
//         Fluttertoast.showToast(
//           msg: "Image uploaded successfully!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       } else if (mimeType.startsWith('video/')) {
//         // Save to 'reels' collection
//         await FirebaseFirestore.instance.collection('reels').add({
//           'mediaUrl': downloadUrl,
//           'uid': user.uid,
//           'timestamp': FieldValue.serverTimestamp(),
//           'username': username,
//           'userProfileImageUrl': userProfileImageUrl,
//         });
//         Fluttertoast.showToast(
//           msg: "Video uploaded successfully!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       } else {
//         // Unsupported file type
//         Fluttertoast.showToast(
//           msg: "Unsupported media type",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error uploading media: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }
//   }
//
// // Function to get mime type from file extension
//   String? _getMimeType(String extension) {
//     switch (extension) {
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'gif':
//         return 'image/gif';
//       case 'mp4':
//         return 'video/mp4';
//       case 'mov':
//         return 'video/quicktime';
//       // Add more cases as needed
//       default:
//         return null; // Unsupported file type
//     }
//   }
// }

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'controller/home_controller.dart';
import 'controller/post_controller.dart';
import 'insta_home.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'rells_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

final HomeController controller = Get.put(HomeController());
final AddPostController addPostController = Get.put(AddPostController());
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _BottomNavBarState extends State<BottomNavBar> {
  ValueNotifier<PlatformFile?> image = ValueNotifier<PlatformFile?>(null);
  ValueNotifier<PlatformFile?> video = ValueNotifier<PlatformFile?>(null);
  List<Widget> screenname = [
    HomePage(),
    InstaSearchScreen(),
    Container(), // Placeholder for Add button action
    RellsScreenInsta(),
    ProfileScreen(),
  ];

  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedScreen,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.smart_display_outlined, size: 30), label: ""),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: height * 0.02,
              backgroundColor: Colors.grey,
              child: CachedNetworkImage(
                imageUrl: controller.userProfileImageUrl.value.isNotEmpty
                    ? controller.userProfileImageUrl.value
                    : 'https://via.placeholder.com/150',
                imageBuilder: (context, imageProvider) => Container(
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            label: "",
          ),
        ],
        onTap: (value) {
          if (value == 2) {
            // Open gallery to select an image or video
            _pickMedia();
          } else {
            // Update selected screen for other tabs
            setState(() {
              selectedScreen = value;
            });
          }
        },
      ),
      body: screenname[selectedScreen],
    );
  }

  void _pickMedia() async {
    final ImagePicker picker = ImagePicker();

    // Picking image
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      // Navigate to preview screen
      Get.to(() => MediaPreviewScreen(mediaFile: selectedImage));
      return; // Exit after handling image
    }

    // Picking video
    final XFile? selectedVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      // Navigate to preview screen
      Get.to(() => MediaPreviewScreen(mediaFile: selectedVideo));
    }
  }

  Future<void> pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media, // This allows picking both images and videos
      allowMultiple:
          false, // Set to true if you want to allow picking multiple files
    );

    if (result != null) {
      final pickedFile = result.files.first;

      // Check if the selected file is an image or a video
      if (pickedFile.extension == 'jpg' ||
          pickedFile.extension == 'png' ||
          pickedFile.extension == 'jpeg') {
        // Handle image
        image.value = pickedFile;
      } else if (pickedFile.extension == 'mp4' ||
          pickedFile.extension == 'mov' ||
          pickedFile.extension == 'avi') {
        // Handle video
        video.value = pickedFile;
      }
    } else {
      // User canceled the picker
      print("No media selected");
    }
  }
}

class MediaPreviewScreen extends StatelessWidget {
  final XFile mediaFile;

  MediaPreviewScreen({required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    bool isImage =
        mediaFile.mimeType != null && mediaFile.mimeType!.startsWith('image/');

    return Scaffold(
      body: Center(
        child: isImage
            ? Image.file(File(mediaFile.path))
            : VideoPlayerScreen(videoFile: mediaFile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _uploadMedia(mediaFile);
        },
        child: Icon(Icons.upload),
      ),
    );
  }
}

Future<void> _uploadMedia(XFile mediaFile) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "User not authenticated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Exit if user is not authenticated
    }

    String? mimeType = mediaFile.mimeType;

    if (mimeType == null) {
      String fileExtension = mediaFile.path.split('.').last.toLowerCase();
      mimeType = _getMimeType(fileExtension);
      if (mimeType == null) {
        Fluttertoast.showToast(
          msg: "Unsupported file type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return; // Exit if mime type is unsupported
      }
    }

    DocumentSnapshot snapshot =
        await _firestore.collection('InstaUser').doc(user.uid).get();

    String username = snapshot.exists && snapshot.data() != null
        ? (snapshot.data() as Map<String, dynamic>)['username'] ??
            'Unknown User'
        : 'Unknown User';

    String userProfileImageUrl = snapshot.exists && snapshot.data() != null
        ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
        : '';

    String filePath =
        'media/${DateTime.now().millisecondsSinceEpoch}.$mimeType';
    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    await ref.putFile(File(mediaFile.path));

    String downloadUrl = await ref.getDownloadURL();

    if (mimeType.startsWith('image/')) {
      await FirebaseFirestore.instance.collection('posts').add({
        'mediaUrl': downloadUrl,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
      });
      Fluttertoast.showToast(
        msg: "Image uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (mimeType.startsWith('video/')) {
      await FirebaseFirestore.instance.collection('reels').add({
        'mediaUrl': downloadUrl,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
      });
      Fluttertoast.showToast(
        msg: "Video uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // Navigate back to the home screen after upload
    Get.offAll(() => BottomNavBar());
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error uploading media: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

String? _getMimeType(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'mp4':
      return 'video/mp4';
    case 'mov':
      return 'video/quicktime';
    // Add more cases as needed
    default:
      return null; // Unsupported file type
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final XFile videoFile;

  VideoPlayerScreen({required this.videoFile});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.hasError) {
      return Center(
        child: Text("Unable to play video. Please try again later."),
      );
    }

    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }
}
