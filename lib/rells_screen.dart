import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/reels_controller.dart';

class RellsScreenInsta extends StatelessWidget {
  const RellsScreenInsta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reels')),
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
            return Center(child: Text('Error: ${controller.errorMessage}'));
          }

          if (controller.videoUrls.isEmpty) {
            return Center(child: Text('No videos found.'));
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
