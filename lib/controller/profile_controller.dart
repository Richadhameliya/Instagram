// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
//
// class UserController extends ChangeNotifier {
//   bool isLoading = true;
//   Map<String, dynamic> userData = {};
//   List<Map<String, dynamic>> posts = [];
//   List<Map<String, dynamic>> reels = [];
//
//   UserController() {
//     fetchUserData();
//     fetchUserPosts();
//     fetchUserReels();
//   }
//
//   Future<void> fetchUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .get();
//
//       userData = snapshot.data() as Map<String, dynamic>;
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> fetchUserPosts() async {
//     final user = FirebaseAuth.instance.currentUser;
//     final user1 = FirebaseAuth.instance.currentUser!.uid;
//     print('$user1');
//
//     if (user != null) {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', isEqualTo: user.uid)
//           .get();
//
//       posts = snapshot.docs.map((doc) {
//         return {'mediaUrl': doc['mediaUrl'], 'uid': doc['uid']};
//       }).toList();
//
//       print('$posts');
//
//       notifyListeners();
//     }
//   }
//
//   Future<void> fetchUserReels() async {
//     final user = FirebaseAuth.instance.currentUser;
//     final user1 = FirebaseAuth.instance.currentUser!.uid;
//     print('$user1');
//
//     if (user != null) {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('reels')
//           .where('uid', isEqualTo: user.uid)
//           .get();
//
//       reels = snapshot.docs.map((doc) {
//         return {'mediaUrl': doc['mediaUrl'], 'uid': doc['uid']};
//       }).toList();
//
//       print('$reels');
//
//       notifyListeners();
//     }
//   }
// }
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

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          userData = snapshot.data() as Map<String, dynamic>? ?? {};
        } else {
          userData = {};
        }
      } catch (e) {
        print('Error fetching user data: $e');
      } finally {
        isLoading = false;
        notifyListeners(); // Notify listeners that data has been updated
      }
    } else {
      isLoading = false; // Set loading to false if no user is logged in
      notifyListeners();
    }
  }

  // Fetch user posts from Firestore
  Future<void> fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: user.uid)
            .get();

        posts = snapshot.docs.map((doc) {
          return {
            'mediaUrl': doc['mediaUrl'],
            'uid': doc['uid'],
            // Add any other fields you need
          };
        }).toList();
      } catch (e) {
        print('Error fetching user posts: $e');
      } finally {
        notifyListeners(); // Notify listeners that posts have been updated
      }
    }
  }

  // Fetch user reels from Firestore
  Future<void> fetchUserReels() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('reels')
            .where('uid', isEqualTo: user.uid)
            .get();

        reels = snapshot.docs.map((doc) {
          return {
            'mediaUrl': doc['mediaUrl'],
            'uid': doc['uid'],
            // Add any other fields you need
          };
        }).toList();
      } catch (e) {
        print('Error fetching user reels: $e');
      } finally {
        notifyListeners(); // Notify listeners that reels have been updated
      }
    }
  }
}
