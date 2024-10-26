import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/constant/app_string.dart';
import 'package:instagram_app/helper/helper.dart';
import 'package:instagram_app/ui/main/add_post/add_image_screen.dart';
import '../ui/main/bottombar/bottom_bar.dart';

class PostAddController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ValueNotifier<PlatformFile?> image = ValueNotifier<PlatformFile?>(null);
  ValueNotifier<PlatformFile?> video = ValueNotifier<PlatformFile?>(null);
  void pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result != null) {
      final pickedFile = result.files.first;

      // Convert PlatformFile to XFile
      final xFile = XFile(pickedFile.path!);

      if (pickedFile.extension == 'jpg' ||
          pickedFile.extension == 'png' ||
          pickedFile.extension == 'jpeg') {
        image.value = pickedFile;
        // Navigate to MediaPreviewScreen
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      } else if (pickedFile.extension == 'mp4' ||
          pickedFile.extension == 'mov' ||
          pickedFile.extension == 'avi') {
        video.value = pickedFile;
        // Navigate to MediaPreviewScreen
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      }
    } else {
      print("No media selected");
    }
  }

  Future<void> uploadMedia(XFile mediaFile, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Helper.dialogCall.showToast(context, AppString.userNotAuthenticated,
            Colors.black, Colors.white);
        return;
      }

      String? mimeType = mediaFile.mimeType;

      if (mimeType == null) {
        String fileExtension = mediaFile.path.split('.').last.toLowerCase();
        mimeType = _getMimeType(fileExtension);
        if (mimeType == null) {
          Helper.dialogCall.showToast(context, AppString.unSupportedFileType,
              Colors.black, Colors.white);
          return;
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
        Helper.dialogCall.showToast(context,
            AppString.imageUploadedSuccessfully, Colors.black, Colors.white);
      } else if (mimeType.startsWith('video/')) {
        await FirebaseFirestore.instance.collection('reels').add({
          'mediaUrl': downloadUrl,
          'uid': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'username': username,
          'userProfileImageUrl': userProfileImageUrl,
        });
        Helper.dialogCall.showToast(context,
            AppString.videoUploadedSuccessfully, Colors.black, Colors.white);
      }

      Get.offAll(() => BottomNavBar());
    } catch (e) {
      Helper.dialogCall.showToast(context,
          "${AppString.errorUploadingMedia} $e", Colors.black, Colors.white);
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

      default:
        return null;
    }
  }
}
