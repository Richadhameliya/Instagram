import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserController extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> reels = [];

  UserController() {
    fetchUserData();
    fetchUserPosts();
    fetchUserReels();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      userData = snapshot.data() as Map<String, dynamic>;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    final user1 = FirebaseAuth.instance.currentUser!.uid;
    print('$user1');

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user.uid)
          .get();

      posts = snapshot.docs.map((doc) {
        return {'imageUrl': doc['imageUrl'], 'uid': doc['uid']};
      }).toList();

      print('$posts');

      notifyListeners();
    }
  }

  Future<void> fetchUserReels() async {
    final user = FirebaseAuth.instance.currentUser;
    final user1 = FirebaseAuth.instance.currentUser!.uid;
    print('$user1');

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reels')
          .where('uid', isEqualTo: user.uid)
          .get();

      reels = snapshot.docs.map((doc) {
        return {'videoUrl': doc['videoUrl'], 'uid': doc['uid']};
      }).toList();

      print('$reels');

      notifyListeners();
    }
  }
}
