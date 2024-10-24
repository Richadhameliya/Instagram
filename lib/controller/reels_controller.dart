import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class RellsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> videoUrls = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchVideoUrls() async {
    try {
      isLoading = true;
      update();

      QuerySnapshot snapshot = await _firestore.collection('reels').get();
      videoUrls =
          snapshot.docs.map((doc) => doc['mediaUrl'] as String).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: screenHeight * 0.99,
//           margin: EdgeInsets.only(bottom: 3),
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_controller.value.isInitialized)
//                 AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               else
//                 Center(child: CircularProgressIndicator()),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 380,
//           right: 190,
//           child: IconButton(
//             icon: Icon(
//               _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               color: Colors.white,
//               size: 30,
//             ),
//             onPressed: () {
//               setState(() {
//                 _controller.value.isPlaying
//                     ? _controller.pause()
//                     : _controller.play();
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
