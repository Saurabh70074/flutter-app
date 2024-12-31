class Video {
  final String id;
  final String title;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  // Convert JSON data into a Video object
  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['resourceId']['videoId'],
      title: map['title'],
      thumbnailUrl: map['thumbnails']['high']['url'],
    );
  }
}
