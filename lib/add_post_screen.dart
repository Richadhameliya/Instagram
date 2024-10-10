// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import 'controller/post_controller.dart';
// //
// // class AddPostScreen extends StatelessWidget {
// //   final AddPostController _controller = Get.put(AddPostController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Post'),
// //         actions: [
// //           Obx(() => IconButton(
// //                 icon: Icon(Icons.upload_file),
// //                 onPressed: _controller.isUploading.value
// //                     ? null
// //                     : _controller.uploadImage, // Disable button if uploading
// //               )),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: Obx(() {
// //             if (_controller.isUploading.value) {
// //               return CircularProgressIndicator(); // Show progress indicator if uploading
// //             } else {
// //               return Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   _controller.image.value == null
// //                       ? Text("No image selected.")
// //                       : Column(
// //                           children: [
// //                             Image.file(File(_controller.image.value!.path)),
// //                             SizedBox(height: 20),
// //                           ],
// //                         ),
// //                   // Show the icon only if no image is selected
// //                   if (_controller.image.value == null)
// //                     IconButton(
// //                       icon: Icon(Icons.add_a_photo),
// //                       iconSize: 50,
// //                       onPressed: _controller.pickImage,
// //                     ),
// //                 ],
// //               );
// //             }
// //           }),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'controller/post_controller.dart';
//
// class AddPostScreen extends StatelessWidget {
//   final AddPostController _controller = Get.put(AddPostController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Post'),
//         actions: [
//           Obx(() => IconButton(
//                 icon: Icon(Icons.upload_file),
//                 onPressed: _controller.isUploading.value
//                     ? null
//                     : _controller.uploadPost, // Disable button if uploading
//               )),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Obx(() {
//             if (_controller.isUploading.value) {
//               return CircularProgressIndicator(); // Show progress indicator if uploading
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (_controller.image.value != null)
//                     Column(
//                       children: [
//                         Image.file(File(_controller.image.value!.path)),
//                         SizedBox(height: 20),
//                       ],
//                     )
//                   else if (_controller.video.value != null)
//                     Column(
//                       children: [
//                         // Placeholder for video thumbnail or a play button
//                         Icon(Icons.video_collection, size: 100),
//                         SizedBox(height: 20),
//                       ],
//                     )
//                   else
//                     Text("No media selected."),
//
//                   // Button for picking an image
//                   if (_controller.image.value == null &&
//                       _controller.video.value == null)
//                     IconButton(
//                       icon: Icon(Icons.add_a_photo),
//                       iconSize: 50,
//                       onPressed: _controller.pickImage,
//                     ),
//
//                   // Button for picking a video
//                   if (_controller.image.value == null &&
//                       _controller.video.value == null)
//                     IconButton(
//                       icon: Icon(Icons.video_library),
//                       iconSize: 50,
//                       onPressed: _controller.pickVideo,
//                     ),
//                 ],
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'controller/post_controller.dart';

class AddPostScreen extends StatelessWidget {
  final AddPostController _controller = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(Icons.upload_file),
                onPressed: _controller.isUploading.value
                    ? null
                    : _controller.uploadPost, // Disable button if uploading
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() {
            if (_controller.isUploading.value) {
              return CircularProgressIndicator(); // Show progress indicator if uploading
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_controller.image.value != null)
                    Column(
                      children: [
                        Image.file(File(_controller.image.value!.path)),
                        SizedBox(height: 20),
                      ],
                    )
                  else if (_controller.video.value != null)
                    Column(
                      children: [
                        // Display video thumbnail
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child:
                              VideoPlayer(_controller.videoPlayerController!),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                  else
                    Text("No media selected."),

                  // Button for picking an image
                  if (_controller.image.value == null &&
                      _controller.video.value == null)
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 50,
                      onPressed: _controller.pickImage,
                    ),

                  // Button for picking a video
                  if (_controller.image.value == null &&
                      _controller.video.value == null)
                    IconButton(
                      icon: Icon(Icons.video_library),
                      iconSize: 50,
                      onPressed: _controller.pickVideo,
                    ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
