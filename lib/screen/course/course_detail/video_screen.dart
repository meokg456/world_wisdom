import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      flickManager.flickControlManager.enterFullscreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    VideoPlayerController videoPlayerController =
        ModalRoute.of(context).settings.arguments;
    flickManager = FlickManager(videoPlayerController: videoPlayerController);
    flickManager.flickControlManager.addListener(() {
      if (!flickManager.flickControlManager.isFullscreen) {
        Navigator.pop(context);
      }
    });
    return Container(
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}
