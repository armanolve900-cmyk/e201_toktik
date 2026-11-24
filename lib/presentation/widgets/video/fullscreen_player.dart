import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final VideoPost video;
  final VoidCallback? onVideoUpdated; // 1. Callback agregado

  const FullscreenPlayer({
    super.key,
    required this.video,
    this.onVideoUpdated,
  });

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.video.url)
      ..setVolume(0)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          controller.play();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          onDoubleTap: () {
            setState(() {
              widget.video.likes++;
            });
            widget.onVideoUpdated?.call(); // 2. Notifica al padre para redibujar el botón de likes
            
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(''),
                duration: Duration(milliseconds: 100),
              ),
            );
          },
          onLongPress: () {
            setState(() {
              widget.video.views++;
            });
            widget.onVideoUpdated?.call(); // 3. Notifica al padre para redibujar el botón de vistas
            controller.seekTo(Duration.zero);
            
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('👀 +1 Vista (Video reiniciado)'),
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(controller),
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: _VideoCaption(caption: widget.video.caption),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;
  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return SizedBox(
      width: size.width * 0.6,
      child: Text(
        caption,
        maxLines: 2,
        style: titleStyle?.copyWith(color: Colors.white),
      ),
    );
  }
}