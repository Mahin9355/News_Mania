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

  // GNews
  factory News.fromGNews(Map<String, dynamic> json, String category) {
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

  // TheNewsAPI
  factory News.fromTheNewsAPI(Map<String, dynamic> json, String defaultCategory) {
    return News(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      publishedAt: json['published_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
      content: json['description'] ?? '',
      category: (json['categories'] is List && json['categories'].isNotEmpty)
          ? json['categories'][0]
          : defaultCategory,
      saved: false,
    );
  }

  // Mediastack
  factory News.fromMediastack(Map<String, dynamic> json, String defaultCategory) {
    return News(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      publishedAt: json['published_at'] ?? '',
      imageUrl: json['image'] ?? '',
      content: json['description'] ?? '',
      category: json['category'] ?? defaultCategory,
      saved: false,
    );
  }

  // NewsData.io
  factory News.fromNewsData(Map<String, dynamic> json, String defaultCategory) {
    return News(
      title: json['title'] ?? '',
      source: json['source_id'] ?? '',
      publishedAt: json['pubDate'] ?? '',
      imageUrl: json['image_url'] ?? '',
      content: json['description'] ?? '',
      category: (json['categories'] is List && json['categories'].isNotEmpty)
          ? json['categories'][0]
          : defaultCategory,
      saved: false,
    );
  }

  // The Guardian
  factory News.fromTheGuardian(Map<String, dynamic> json, String defaultCategory) => News(
      title: json['webTitle'] ?? '',
      source: json['source_id'] ?? 'The Guardian',
      publishedAt: json['webPublicationDate'] ?? '',
      imageUrl: json['image_url'] ?? '',
      content: json['webTitle'] ?? '',
      category: (json['categories'] is List && json['categories'].isNotEmpty)
          ? json['categories'][0]
          : defaultCategory,
      saved: false,
    );
}