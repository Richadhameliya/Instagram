import 'package:flutter/material.dart';

class StoryDetailScreen extends StatelessWidget {
  final String storyUrl;

  const StoryDetailScreen({Key? key, required this.storyUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(storyUrl, fit: BoxFit.cover),
      ),
    );
  }
}
