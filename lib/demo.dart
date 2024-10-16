import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class MediaPreviewScreen extends StatefulWidget {
  final XFile mediaFile;

  const MediaPreviewScreen({Key? key, required this.mediaFile})
      : super(key: key);

  @override
  _MediaPreviewScreenState createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.mediaFile.mimeType!.startsWith('video/')) {
      _controller = VideoPlayerController.file(File(widget.mediaFile.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () async {
              // Here you can call your upload function
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: widget.mediaFile.mimeType!.startsWith('image/')
            ? Image.file(File(widget.mediaFile.path), fit: BoxFit.cover)
            : _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : CircularProgressIndicator(),
      ),
    );
  }
}
