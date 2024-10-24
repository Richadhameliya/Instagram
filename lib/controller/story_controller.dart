import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class StoryController extends GetxController {
  var userStoryUrls = <String>[].obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      await uploadStory(selectedImage.path);
    }
  }

  Future<void> uploadStory(String filePath) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('InstaUser').doc(user.uid);

        final storageRef = FirebaseStorage.instance.ref();
        final fileName =
            '${user.uid}/story/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final imageRef = storageRef.child(fileName);

        await imageRef.putFile(File(filePath));

        final downloadUrl = await imageRef.getDownloadURL();

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userDoc);

          List<dynamic> stories = [];
          if (snapshot.exists && snapshot.data() != null) {
            final data = snapshot.data() as Map<String, dynamic>;
            if (data.containsKey('stories')) {
              stories = List<dynamic>.from(data['stories']);
            }
          }

          stories.add({
            'url': downloadUrl,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });

          transaction.update(userDoc, {'stories': stories});
        });

        userStoryUrls.add(downloadUrl);
      } catch (e) {
        print("Failed to upload story: $e");
      }
    }
  }
}
