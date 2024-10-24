import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/bottombar_controller.dart';
import 'add_video_screen.dart';

class MediaPreviewScreen extends StatelessWidget {
  final BottombarController bottombarController =
      Get.put(BottombarController());

  final XFile mediaFile;

  MediaPreviewScreen({super.key, required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    bool isImage =
        mediaFile.mimeType != null && mediaFile.mimeType!.startsWith('image/');

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: isImage
                ? Container(
                    height: 400,
                    width: double.infinity, // Full width
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(mediaFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : VideoPlayerScreen(videoFile: mediaFile),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            height: 50,
            minWidth: 100,
            color: Colors.grey,
            child: const Text(
              "Post",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              bottombarController.uploadMedia(mediaFile);
            },
          ),
        ],
      ),
    );
  }
}
