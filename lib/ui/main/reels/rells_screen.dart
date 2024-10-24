import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/constant/app_string.dart';
import 'package:instagram_app/controller/reels_controller.dart';
import 'package:video_player/video_player.dart';

class RellsScreenInsta extends StatelessWidget {
  const RellsScreenInsta({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(AppString.reels)),
      body: GetBuilder<RellsController>(
        init: RellsController(),
        builder: (controller) {
          if (controller.videoUrls.isEmpty) {
            controller.fetchVideoUrls();
          }

          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
                child: Text('${AppString.error}: ${controller.errorMessage}'));
          }

          if (controller.videoUrls.isEmpty) {
            return Center(child: Text(AppString.noVideoFound));
          }

          return ListView.builder(
            itemCount: controller.videoUrls.length,
            itemBuilder: (context, index) {
              return VideoPlayerWidget(videoUrl: controller.videoUrls[index]);
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight * 0.99,
          margin: EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_controller.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              else
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        Positioned(
          top: 380,
          right: 190,
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        ),
      ],
    );
  }
}
