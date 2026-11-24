class VideoPost {
  final String caption;
  final String url;
  int likes;
  int views;
  List<String> comments; // 1. Se agrega la lista de comentarios

  VideoPost({
    required this.caption,
    required this.url,
    this.likes = 0,
    this.views = 0,
    List<String>? comments, // 2. Comentarios opcionales en el constructor
  }) : comments = comments ?? [
          '¡Excelente video! 🔥',
          'Saludos desde el Tec 🚀',
        ];
}