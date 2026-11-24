import 'package:animate_do/animate_do.dart';
import 'package:e201_toktik/config/helpers/human_formats.dart';
import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

class VideoBottons extends StatefulWidget {

  final VideoPost video;
  const VideoBottons({super.key, required this.video});

  @override
  State<VideoBottons> createState() => _VideoBottonsState();
}

class _VideoBottonsState extends State<VideoBottons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomIconButton(
          icon: Icons.favorite, 
          value: widget.video.likes,
          iconColor: Colors.red,
          onPressed: () {
            setState(() {
              widget.video.likes++;
            });
          },
        ),
        const SizedBox(height: 20,),
        _CustomIconButton(
          icon: Icons.remove_red_eye_outlined, 
          value: widget.video.views,
          onPressed: () {
            setState(() {
              widget.video.views++;
            });
          },
        ),
        const SizedBox(height: 20,),
        _CustomIconButton(
          icon: Icons.message_outlined, 
          value: widget.video.comments.length,
          onPressed: () => _showCommentsModal(context),
        ),
        const SizedBox(height: 20,),
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: const _CustomIconButton(
            icon: Icons.play_circle_outline, 
            value: 0
          ),
        ),
      ]
    );
  }

  void _showCommentsModal(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15, left: 15, right: 15,
              ),
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Comentarios (${widget.video.comments.length})',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(color: Colors.white24),
                    Expanded(
                      child: widget.video.comments.isEmpty
                          ? const Center(child: Text('Aún no hay comentarios', style: TextStyle(color: Colors.white54)))
                          : ListView.builder(
                              itemCount: widget.video.comments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(
                                    widget.video.comments[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Agregar un comentario...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.indigoAccent),
                            onPressed: () {
                              if (textController.text.trim().isNotEmpty) {
                                setModalState(() {
                                  widget.video.comments.add(textController.text.trim());
                                });
                                setState(() {});
                                textController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color ? color;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.icon, 
    required this.value, 
    iconColor,
    this.onPressed,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed ?? (){}, 
          icon: Icon(icon, color: color, size: 30),
        ),
        if(value > 0)
          Text(
            HumanFormats.humanReadableNumber(value.toDouble()),
            style: const TextStyle(color: Colors.white),
          )
      ],
    );
  }
}