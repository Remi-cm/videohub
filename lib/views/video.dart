import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:videohub/core/models/video_model.dart';

class VideoView extends StatefulWidget {
  final VideoModel video;
  final File? videoFile;
  const VideoView({super.key, required this.video, this.videoFile});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  
  late VideoPlayerController videoController;
  ChewieController? chewieController;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    if(widget.videoFile != null){
      videoController = VideoPlayerController.file(widget.videoFile!)
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: true,
          looping: true
        );
        setState(() {});
      });
      return;
    }
    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video.url!))
    ..initialize().then((_) {
      chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: true
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.video.name ?? "Player"),
        actions: [IconButton(onPressed: ()=>context.pop(), icon: Icon(Icons.close))],
      ),
      body: Center(
        child: chewieController?.videoPlayerController.value.isInitialized == true
            ? AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: Chewie(controller: chewieController!),
              )
            : CircularProgressIndicator.adaptive(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
    chewieController?.dispose();
  }
}