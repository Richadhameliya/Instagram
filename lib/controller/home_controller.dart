import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeController extends GetxController {
  var posts = <Map<String, dynamic>>[].obs;
  var userProfileImageUrl = ''.obs;
  var username = ''.obs;
  var userStoryUrls = <String>[].obs;
  var followedUserStories = <Map<String, dynamic>>[].obs;
  final Rx<XFile?> image = Rx<XFile?>(null);

  var favorites = <bool>[].obs;
  var saved = <bool>[].obs;
  var userFavorites = <String>[].obs;
  var userBookmarks = <String>[].obs;
  var following = <String>[].obs;
  var commentsMap = <String, String>{}.obs;
  var comments = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchProfile();
        fetchFollowingList();
        fetchUserFavorites();
        fetchUserBookmarks();
        fetchUserStories();
      } else {
        resetData();
      }
    });
  }

  void resetData() {
    userProfileImageUrl.value = '';
    username.value = '';
    userStoryUrls.clear();
    posts.clear();
    favorites.clear();
    userFavorites.clear();
    userBookmarks.clear();
    following.clear();
    followedUserStories.clear();
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
          following.value =
              List<String>.from(data['following'] as List<dynamic>);
        } else {
          following.value = [];
        }

        fetchFollowedUserStories();
        listenForPostUpdates();
      }
    }
  }

  Future<void> fetchFollowedUserStories() async {
    followedUserStories.clear();

    if (following.isNotEmpty) {
      for (String followedUserId in following) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(followedUserId)
            .get();

        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;

          if (data.containsKey('stories') && data['stories'] is List) {
            List<dynamic> stories = List<dynamic>.from(data['stories']);
            if (stories.isNotEmpty) {
              followedUserStories.add({
                'username': data['username'] ?? 'Unknown',
                'profileImageUrl': data['imageUrl'] ?? '',
                'storyUrls': stories.map((story) => story['url']).toList(),
              });
            }
          }
        }
      }
    }
  }

  Future<void> fetchUserStories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;
          userStoryUrls.value = data['stories'] != null
              ? List<String>.from(
                  data['stories'].map((story) => story['url'].toString()))
              : [];
        }
      });
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
                .listen((QuerySnapshot snapshot) async {
              posts.value = snapshot.docs.map((doc) {
                return {
                  'mediaUrl': doc['mediaUrl'],
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
          userFavorites.value =
              List<String>.from(data['favorites'] as List<dynamic>);
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

  Future<void> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        userProfileImageUrl.value = data['imageUrl'] ?? '';
        username.value = data['username'] ?? '';
      }
    }
  }

  void fetchLastComment(String postId) async {
    QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (commentSnapshot.docs.isNotEmpty) {
      // Assign the comment data to the map
      comments[postId] =
          commentSnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      // Assign an empty map if no comment is found
      comments[postId] = {};
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    resetData();
  }
}
