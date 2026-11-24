import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/presentation/widgets/shared/video_bottons.dart';
import 'package:e201_toktik/presentation/widgets/video/fullscreen_player.dart';
import 'package:flutter/material.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;

  const VideoScrollableView({
    super.key, 
    required this.videos,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            SizedBox.expand(
              child: FullscreenPlayer(
                video: videoPost,
                onVideoUpdated: () {
                  setState(() {}); // Ahora funciona perfectamente
                },
              ),
            ),

            Positioned(
              bottom: 40,
              right: 20,
              child: VideoBottons(video: videoPost),
            ),
          ],
        );
      },
    );
  }
}