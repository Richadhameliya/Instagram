// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class SearchScreenController extends GetxController {
//   var searchResults = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;
//   var allImages = <String>[].obs;
//   var showImages = true.obs;
//   var followingUsers = <String>[].obs;
//   var followerChanges = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllImages();
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         listenForFollowingUsers();
//       } else {
//         resetData();
//       }
//     });
//   }
//
//   void resetData() {
//     followingUsers.clear();
//     followerChanges.clear(); // Reset follower changes when user logs out
//   }
//
//   void listenForFollowingUsers() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .snapshots()
//           .listen((DocumentSnapshot snapshot) {
//         if (snapshot.exists && snapshot.data() != null) {
//           final data = snapshot.data() as Map<String, dynamic>;
//           followingUsers.value = List<String>.from(data['following'] ?? []);
//         }
//       });
//     }
//   }
//
//   bool isFollowing(String userId) {
//     return followingUsers.contains(userId);
//   }
//
//   void toggleFollow(String userId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String currentUserId = user.uid;
//
//       try {
//         DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
//             .collection('InstaUser')
//             .doc(currentUserId)
//             .get();
//
//         DocumentSnapshot targetUserDoc = await FirebaseFirestore.instance
//             .collection('InstaUser')
//             .doc(userId)
//             .get();
//
//         // Check if the documents exist
//         if (!currentUserDoc.exists || !targetUserDoc.exists) {
//           print("User document does not exist");
//           return;
//         }
//
//         // Safely retrieve following and followers lists
//         List<dynamic> followingList =
//             (currentUserDoc.data() as Map<String, dynamic>?)?['following'] ??
//                 [];
//         List<dynamic> followersList =
//             (targetUserDoc.data() as Map<String, dynamic>?)?['followers'] ?? [];
//
//         if (followingList.contains(userId)) {
//           // Unfollow
//           followingList.remove(userId);
//           followersList.remove(currentUserId);
//           followerChanges.add(
//               'Unfollowed: $userId'); // Remove from target user's followers
//         } else {
//           // Follow
//           followingList.add(userId);
//           if (!followersList.contains(currentUserId)) {
//             followersList.add(currentUserId); // Add to target user's followers
//             followerChanges.add('Followed: $userId'); // Log follow
//           }
//         }
//
//         // Update the following list of the current user
//         await FirebaseFirestore.instance
//             .collection('InstaUser')
//             .doc(currentUserId)
//             .update({'following': followingList});
//
//         // Update the followers list of the target user
//         await FirebaseFirestore.instance
//             .collection('InstaUser')
//             .doc(userId)
//             .update({'followers': followersList});
//
//         listenForFollowingUsers();
//       } catch (e) {
//         print('Error toggling follow: $e');
//       }
//     }
//   }
//
//   void searchUsers(String query) async {
//     if (query.isEmpty) {
//       searchResults.clear();
//       showImages(true);
//       return;
//     }
//
//     isLoading(true);
//     showImages(false);
//
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .where('username', isGreaterThanOrEqualTo: query)
//           .where('username', isLessThanOrEqualTo: query + '\uf8ff')
//           .get();
//
//       List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
//         return {
//           'uid': doc.id, // Store user ID for follow/unfollow
//           'username': doc['username'],
//           'email': doc['email'],
//           'profileImageUrl': doc['imageUrl'],
//           'isFollowing': isFollowing(doc.id), // Add isFollowing status
//         };
//       }).toList();
//
//       searchResults.assignAll(results);
//     } catch (e) {
//       print('Error searching users: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   void fetchAllImages() {
//     isLoading(true);
//
//     FirebaseFirestore.instance.collectionGroup('posts').snapshots().listen(
//         (snapshot) {
//       List<String> images = snapshot.docs.map((doc) {
//         return (doc['imageUrl'] ?? '') as String;
//       }).toList();
//
//       allImages.assignAll(images);
//     }, onError: (e) {
//       print('Error fetching images: $e');
//     });
//
//     isLoading(false);
//   }
//
//   void hideImages() {
//     showImages(false);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var allImages = <String>[].obs;
  var showImages = true.obs;
  var followingUsers = <String>[].obs;
  var followers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllImages();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        listenForFollowingUsers();
      } else {
        resetData();
      }
    });
  }

  void resetData() {
    followingUsers.clear();
    followers.clear();
  }

  void listenForFollowingUsers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;
          followingUsers.value = List<String>.from(data['following'] ?? []);
          followers.value = List<String>.from(data['followers'] ?? []);
        }
      });
    }
  }

  bool isFollowing(String userId) {
    return followingUsers.contains(userId);
  }

  void toggleFollow(String userId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUserId = user.uid;

      try {
        DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(currentUserId)
            .get();

        DocumentSnapshot targetUserDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .get();

        if (!currentUserDoc.exists || !targetUserDoc.exists) {
          print("User document does not exist");
          return;
        }

        List<dynamic> followingList =
            (currentUserDoc.data() as Map<String, dynamic>?)?['following'] ??
                [];
        List<dynamic> followersList =
            (targetUserDoc.data() as Map<String, dynamic>?)?['followers'] ?? [];

        if (followingList.contains(userId)) {
          followingList.remove(userId);
          followersList.remove(currentUserId);
        } else {
          followingList.add(userId);
          if (!followersList.contains(currentUserId)) {
            followersList.add(currentUserId);
          }
        }

        await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(currentUserId)
            .update({'following': followingList});

        await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .update({'followers': followersList});

        listenForFollowingUsers();
      } catch (e) {
        print('Error toggling follow: $e');
      }
    }
  }

  void searchUsers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      showImages(true);
      return;
    }

    isLoading(true);
    showImages(false);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          'username': doc['username'],
          'email': doc['email'],
          'profileImageUrl': doc['imageUrl'],
          'isFollowing': isFollowing(doc.id),
        };
      }).toList();

      searchResults.assignAll(results);
    } catch (e) {
      print('Error searching users: $e');
    } finally {
      isLoading(false);
    }
  }

  void fetchAllImages() {
    isLoading(true);

    FirebaseFirestore.instance.collectionGroup('posts').snapshots().listen(
        (snapshot) {
      List<String> images = snapshot.docs.map((doc) {
        return (doc['imageUrl'] ?? '') as String;
      }).toList();

      allImages.assignAll(images);
    }, onError: (e) {
      print('Error fetching images: $e');
    });

    isLoading(false);
  }

  void hideImages() {
    showImages(false);
  }
}
