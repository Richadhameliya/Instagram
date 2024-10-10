// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class HomeController extends GetxController {
//   var posts = <Map<String, dynamic>>[].obs;
//   var userProfileImageUrl = ''.obs;
//   var username = ''.obs;
//   final Rx<XFile?> image = Rx<XFile?>(null);
//
//   var favorites = <bool>[].obs;
//   var userFavorites = <String>[].obs;
//   var following = <String>[].obs;
//   var saved = <bool>[].obs;
//   var userBookmarks = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         fetchProfile();
//         fetchFollowingList();
//         fetchUserFavorites();
//         fetchStories();
//         fetchUserBookmarks();
//       } else {
//         resetData();
//       }
//     });
//   }
//
//   void resetData() {
//     userProfileImageUrl.value = '';
//     username.value = '';
//     posts.clear();
//     favorites.clear();
//     userFavorites.clear();
//     following.clear();
//     userBookmarks.clear();
//   }
//
//   Future<void> fetchFollowingList() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .get();
//
//       if (snapshot.exists && snapshot.data() != null) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         following.value = List<String>.from(data['following'] ?? []);
//         listenForPostUpdates();
//       }
//     }
//   }
//
//   void listenForPostUpdates() {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && following.isNotEmpty) {
//       FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', whereIn: following)
//           .orderBy('timestamp', descending: true)
//           .snapshots()
//           .listen((QuerySnapshot snapshot) {
//         posts.value = snapshot.docs.map((doc) {
//           return {
//             'image': doc['imageUrl'],
//             'uid': doc.id,
//             'username': doc['username'],
//             'userProfileImageUrl': doc['userProfileImageUrl'],
//           };
//         }).toList();
//         print("POSTSSSSSSS$posts");
//
//         updateFavoritesList();
//       });
//     } else {
//       posts.clear();
//     }
//   }
//
//   void toggleFavorite(int index) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String postId = posts[index]['uid'];
//       bool isFavorite = favorites[index];
//
//       favorites[index] = !isFavorite;
//
//       if (favorites[index]) {
//         userFavorites.add(postId);
//       } else {
//         userFavorites.remove(postId);
//       }
//
//       updateUserFavorites(user.uid);
//     }
//   }
//
//   Future<void> updateUserFavorites(String userId) async {
//     await FirebaseFirestore.instance
//         .collection('InstaUser')
//         .doc(userId)
//         .update({
//       'favorites': userFavorites,
//     });
//   }
//
//   Future<void> fetchUserFavorites() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .get();
//
//       if (snapshot.exists && snapshot.data() != null) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         userFavorites.value = List<String>.from(data['favorites'] ?? []);
//         updateFavoritesList();
//       }
//     }
//   }
//
//   void updateFavoritesList() {
//     favorites.value = posts.map((post) {
//       return userFavorites.contains(post['uid']);
//     }).toList();
//   }
//
//   Future<void> fetchUserBookmarks() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .get();
//
//       if (snapshot.exists && snapshot.data() != null) {
//         final data = snapshot.data() as Map<String, dynamic>;
//
//         if (data.containsKey('bookmarks') && data['bookmarks'] is List) {
//           userBookmarks.value = List<String>.from(data['bookmarks']);
//         } else {
//           userBookmarks.value = [];
//         }
//         updateBookmarksList();
//       }
//     }
//   }
//
//   void updateBookmarksList() {
//     saved.value = posts.map((post) {
//       return userBookmarks.contains(post['uid']);
//     }).toList();
//   }
//
//   void toggleBookmark(int index) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String postId = posts[index]['uid'];
//       bool isBookmarked = saved[index];
//
//       saved[index] = !isBookmarked;
//
//       if (saved[index]) {
//         userBookmarks.add(postId);
//       } else {
//         userBookmarks.remove(postId);
//       }
//
//       updateUserBookmarks(user.uid);
//     }
//   }
//
//   Future<void> updateUserBookmarks(String userId) async {
//     await FirebaseFirestore.instance
//         .collection('InstaUser')
//         .doc(userId)
//         .update({
//       'bookmarks': userBookmarks,
//     });
//   }
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? selectedImage =
//         await picker.pickImage(source: ImageSource.gallery);
//
//     if (selectedImage != null) {
//       // Upload the image to Firebase Storage
//       String fileName = selectedImage.name;
//       File file = File(selectedImage.path);
//
//       try {
//         // Reference to the Firebase Storage
//         Reference ref =
//             FirebaseStorage.instance.ref().child('stories/$fileName');
//
//         // Upload the file
//         UploadTask uploadTask = ref.putFile(file);
//         TaskSnapshot taskSnapshot = await uploadTask;
//
//         // Get the download URL
//         String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//
//         // Save the URL to Firestore
//         await saveStoryUrl(downloadUrl);
//       } catch (e) {
//         print("Error uploading image: $e");
//       }
//     }
//   }
//
//   Future<void> saveStoryUrl(String url) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Fetch the user's username from Firestore
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .get();
//
//       String username = '';
//       if (userSnapshot.exists && userSnapshot.data() != null) {
//         final data = userSnapshot.data() as Map<String, dynamic>;
//         username = data['username'] ?? ''; // Get the username
//       }
//
//       // Save the story URL with the username
//       await FirebaseFirestore.instance.collection('stories').add({
//         'storyurl': url,
//         'username': username, // Store the username
//       });
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> fetchStories() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('stories').get();
//     return snapshot.docs.map((doc) {
//       return {
//         'storyurl': doc['storyurl'],
//         'username': doc['username'],
//       };
//     }).toList();
//   }
//
//   Future<void> fetchProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('InstaUser')
//           .doc(user.uid)
//           .snapshots()
//           .listen((DocumentSnapshot snapshot) {
//         if (snapshot.exists) {
//           userProfileImageUrl.value = snapshot['imageUrl'] ?? '';
//           username.value = snapshot['username'] ?? '';
//         } else {
//           userProfileImageUrl.value = '';
//           username.value = '';
//         }
//       });
//     }
//   }
//
//   Future<void> logout() async {
//     await FirebaseAuth.instance.signOut();
//     resetData();
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  var posts = <Map<String, dynamic>>[].obs;
  var userProfileImageUrl = ''.obs;
  var username = ''.obs;
  final Rx<XFile?> image = Rx<XFile?>(null);

  var favorites = <bool>[].obs;
  var saved = <bool>[].obs;
  var userFavorites = <String>[].obs;
  var userBookmarks = <String>[].obs;
  var following = <String>[].obs;
  var isLoading = true.obs;
  var storyUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchProfile();
        fetchFollowingList();
        fetchUserFavorites();
        fetchStories();
        fetchUserBookmarks();
      } else {
        resetData();
      }
    });
  }

  void resetData() {
    userProfileImageUrl.value = '';
    username.value = '';
    posts.clear();
    favorites.clear();
    userFavorites.clear();
    userBookmarks.clear();
    following.clear();
  }

  Future<void> fetchFollowingList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('following') && data['following'] is List) {
          following.value = List<String>.from(data['following']);
        } else {
          following.value = [];
        }

        listenForPostUpdates();
      }
    }
  }

  void listenForPostUpdates() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('following') &&
            userData['following'] is List) {
          List<String> followingList = List<String>.from(userData['following']);

          if (followingList.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('posts')
                .where('uid', whereIn: followingList)
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((QuerySnapshot snapshot) {
              posts.value = snapshot.docs.map((doc) {
                return {
                  'image': doc['imageUrl'],
                  'uid': doc.id,
                  'username': doc['username'],
                  'userProfileImageUrl': doc['userProfileImageUrl'],
                };
              }).toList();

              updateFavoritesList();
              updateBookmarksList();
            });
          } else {
            posts.clear();
          }
        }
      }
    } else {
      posts.clear();
    }
  }

  void toggleFavorite(int index) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String postId = posts[index]['uid'];
      bool isFavorite = favorites[index];

      favorites[index] = !isFavorite;

      if (favorites[index]) {
        userFavorites.add(postId);
      } else {
        userFavorites.remove(postId);
      }

      updateUserFavorites(user.uid);
    }
  }

  Future<void> updateUserFavorites(String userId) async {
    await FirebaseFirestore.instance
        .collection('InstaUser')
        .doc(userId)
        .update({
      'favorites': userFavorites,
    });
  }

  Future<void> fetchUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('favorites') && data['favorites'] is List) {
          userFavorites.value = List<String>.from(data['favorites']);
        } else {
          userFavorites.value = [];
        }
        updateFavoritesList();
      }
    }
  }

  void updateFavoritesList() {
    favorites.value = posts.map((post) {
      return userFavorites.contains(post['uid']);
    }).toList();
  }

  Future<void> fetchUserBookmarks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('bookmarks') && data['bookmarks'] is List) {
          userBookmarks.value = List<String>.from(data['bookmarks']);
        } else {
          userBookmarks.value = [];
        }
        updateBookmarksList();
      }
    }
  }

  void updateBookmarksList() {
    saved.value = posts.map((post) {
      return userBookmarks.contains(post['uid']);
    }).toList();
  }

  void toggleBookmark(int index) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String postId = posts[index]['uid'];
      bool isBookmarked = saved[index];

      saved[index] = !isBookmarked;

      if (saved[index]) {
        userBookmarks.add(postId);
      } else {
        userBookmarks.remove(postId);
      }

      updateUserBookmarks(user.uid);
    }
  }

  Future<void> updateUserBookmarks(String userId) async {
    await FirebaseFirestore.instance
        .collection('InstaUser')
        .doc(userId)
        .update({
      'bookmarks': userBookmarks,
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      String fileName = selectedImage.name;
      File file = File(selectedImage.path);

      try {
        Reference ref =
            FirebaseStorage.instance.ref().child('stories/$fileName');

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await saveStoryUrl(downloadUrl);

        Fluttertoast.showToast(
          msg: 'Story added successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> saveStoryUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User snapshot ne fetch karo
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      String username = '';
      if (userSnapshot.exists && userSnapshot.data() != null) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        username = data['username'] ?? ''; // Username fetch karo
      }

      // Stories collection ma story URL save karo
      await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .collection('stories')
          .add({
        'storyurl': url,
        'username': username,
        'timestamp': FieldValue.serverTimestamp(), // Timestamp add karo
      });
    }
  }

  void fetchStories() {
    isLoading.value = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Use a listener to fetch real-time updates from the user's stories subcollection
      FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .collection('stories')
          .snapshots()
          .listen(
        (snapshot) {
          // Keep track of the previous count of URLs
          var previousCount = storyUrls.length;

          storyUrls.clear();

          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>?;

            if (data != null && data.containsKey('storyurl')) {
              storyUrls.add(data['storyurl']);
            } else {
              print("Document ID: ${doc.id} does not have a 'storyurl' field.");
            }
          }

          isLoading.value = false;
          update();
        },
        onError: (error) {
          print("Error listening to stories: $error");
          isLoading.value = false;
        },
      );
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          userProfileImageUrl.value = snapshot['imageUrl'] ?? '';
          username.value = snapshot['username'] ?? '';
        } else {
          userProfileImageUrl.value = '';
          username.value = '';
        }
      });
    }
  }

  Future<void> fetchStoriesfollowing() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('following') &&
            userData['following'] is List) {
          List<String> followingList = List<String>.from(userData['following']);

          final storiesSnapshot = await FirebaseFirestore.instance
              .collection('stories')
              .where('username', whereIn: followingList)
              .get();

          storyUrls.clear();

          for (var doc in storiesSnapshot.docs) {
            final storyData = doc.data() as Map<String, dynamic>;
            storyUrls.add(storyData['storyurl']);
          }
        }
      }
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    resetData();
  }
}
