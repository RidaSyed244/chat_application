import 'package:chat_application/users.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    print("Video: ${widget.videoUrl}");
    if (widget.videoUrl != null && widget.videoUrl.isNotEmpty) {
      // final videoUrl = await ref
      //     .read(signup.notifier)
      //     .downloadVideoURL(widget.videoUrl.toString());

      _videoController = VideoPlayerController.network(widget.videoUrl);

      _videoController?.initialize().then((_) {
        if (mounted) {
          setState(() {
            // Start video playback
            _videoController.play();
          });
        }
      }).catchError((error) {
        print("VideoPlayer initialization error: $error");
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        : Container(); // Show nothing if video is not initialized
  }
}
