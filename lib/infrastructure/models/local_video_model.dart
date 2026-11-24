import 'package:e201_toktik/domain/entities/video_post.dart';

class LocalVideoModel {
  final String videoUrl;
  final String name;
  final int likes;
  final int views;
  final List<String>? comments;

  LocalVideoModel({
    required this.videoUrl,
    required this.name,
    this.likes = 0,
    this.views = 0,
    this.comments,
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) => LocalVideoModel(
        name: json['name'] ?? 'No Name',
        videoUrl: json['videoUrl'],
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
        comments: json['comments'] != null
            ? List<String>.from(json['comments'])
            : null,
      );

  VideoPost toVideoPostEntity() => VideoPost(
        caption: name,
        url: videoUrl,
        likes: likes,
        views: views,
        comments: comments ?? [
          '¡Excelente video! 🔥',
          'Saludos desde el Tec 🚀',
        ],
      );
}

