import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class AddPostController extends GetxController {
  final Rx<XFile?> image = Rx<XFile?>(null);
  final Rx<XFile?> video = Rx<XFile?>(null);
  final RxBool isUploading = false.obs;
  VideoPlayerController? videoPlayerController;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);
    image.value = selectedImage;
    video.value = null;
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
      videoPlayerController = null;
    }
  }

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    video.value = selectedVideo;
    image.value = null;

    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }

    if (video.value != null) {
      videoPlayerController =
          VideoPlayerController.file(File(video.value!.path))
            ..initialize().then((_) {
              update();
            }).catchError((error) {
              Fluttertoast.showToast(
                msg: "Error initializing video: $error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            });
    }
  }

  Future<void> uploadPost() async {
    isUploading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      DocumentSnapshot snapshot =
          await _firestore.collection('InstaUser').doc(user.uid).get();
      if (!snapshot.exists) {
        throw 'User profile not found';
      }

      String username = snapshot['username'];
      String userProfileImageUrl = snapshot['imageUrl'];

      if (image.value != null) {
        String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
        Reference ref = _storage.ref().child(filePath);

        await ref.putFile(File(image.value!.path));
        String downloadUrl = await ref.getDownloadURL();

        await _firestore.collection('posts').add({
          'imageUrl': downloadUrl,
          'uid': user.uid,
          'username': username,
          'userProfileImageUrl': userProfileImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (video.value != null) {
        String videoPath =
            'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
        Reference videoRef = _storage.ref().child(videoPath);

        await videoRef.putFile(File(video.value!.path));
        String videoDownloadUrl = await videoRef.getDownloadURL();

        await _firestore.collection('reels').add({
          'videoUrl': videoDownloadUrl,
          'uid': user.uid,
          'username': username,
          'userProfileImageUrl': userProfileImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      Fluttertoast.showToast(
        msg: "Post added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      image.value = null;
      video.value = null;
      if (videoPlayerController != null) {
        videoPlayerController!.dispose();
        videoPlayerController = null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isUploading.value = false;
    }
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }
}
