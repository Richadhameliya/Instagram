import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_app/constant/app_string.dart';

import '../bottombar/bottom_bar.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  CommentScreen({required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  List<QueryDocumentSnapshot> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        comments = snapshot.docs;
      });
    });
  }

  void _addComment() async {
    if (_controller.text.isNotEmpty) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          print('User Data: $userData');

          String username = userData?['username'];
          String profileImageUrl =
              userData?['imageUrl'] ?? 'https://via.placeholder.com/150';

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .add({
            'comment': _controller.text,
            'username': username,
            'profileImageUrl': profileImageUrl,
            'userId': userId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          _controller.clear();
        } else {
          print('User document does not exist.');
        }
      } else {
        print('No user is currently logged in.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      initialChildSize: 0.60,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppString.comment,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: comments.isEmpty
                    ? Center(child: Text(AppString.noCommentYet))
                    : ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (comments[index].data() as Map<String, dynamic>)
                                        .containsKey('profileImageUrl')
                                    ? comments[index]['profileImageUrl']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                            title: Text(
                              (comments[index].data() as Map<String, dynamic>)
                                      .containsKey('username')
                                  ? comments[index]['username']
                                  : AppString.unKnownUser,
                            ),
                            subtitle: Text(comments[index]['comment']),
                          );
                        },
                      ),
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: controller.userProfileImageUrl.value.isNotEmpty
                          ? controller.userProfileImageUrl.value
                          : 'https://via.placeholder.com/150',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: AppString.typeComment,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _addComment,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
