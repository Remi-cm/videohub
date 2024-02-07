import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videohub/core/models/video_model.dart';
import 'package:videohub/core/services/algorithms.dart';
import 'package:videohub/core/utils/size_config.dart';
import 'package:videohub/views/video.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("VIDEOS").orderBy("dateCreated", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty){
          return const Center(child: Text("No videos added yet"));
        }
        List<VideoModel> videos = snapshot.data!.docs.map((doc) => VideoModel.fromDocument(doc, doc.data() as Map)).toList();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: videos.map((video) => VideoItem(video: video)
          ).toList()
        );
      }
    );
  }
}

class VideoItem extends StatefulWidget {
  final VideoModel video;
  const VideoItem({super.key, required this.video});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  
  late VideoPlayerController videoController;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    if(widget.video.url != null){
      videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video.url!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
      //thumbnailFile = await generateThumbnail(widget.video.url!);
      //setState(() {});
    }
  }

  String? thumbnailFile;

  Future<String?> generateThumbnail(String url) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: url,
      imageFormat: ImageFormat.WEBP,
      maxWidth: 75,
      quality: 75
    );
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: widget.video.thumbnailUrl != null ? DecorationImage(image: FastCachedImageProvider(widget.video.thumbnailUrl!), fit: BoxFit.cover) : null
            ),
            child: videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    )
                  : const Icon(Iconsax.play4, size: 30,),
            //child: thumbnailFile == null ? const Icon(Iconsax.play4, size: 30,) : null,
          ),
          title: Text("${widget.video.name}", style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.video.description ?? "No description", style: const TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 2),
              Text(timeago.format(widget.video.dateCreated!), style: const TextStyle(fontSize: 11, color: Colors.grey),)
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: (){
            Algorithms.showCustomBottomSheet(
              context: context, 
              maxHeight: hv*70,
              child: VideoView(video: widget.video)
            );
          },
        ),
        const Divider(height: 5,)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }
}