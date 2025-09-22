class News {
  final String title;
  final String source;
  final String publishedAt;
  final String imageUrl;
  final String content;
  final String category;
  bool saved;

  News({
    required this.title,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.content,
    required this.category,
    this.saved = false,
  });

  factory News.fromJson(Map<String, dynamic> json, String category) {
    return News(
      title: json['title'] ?? '',
      source: json['source']?['name'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      imageUrl: json['image'] ?? '',
      content: json['content'] ?? '',
      category: category,
      saved: false,
    );
  }
}