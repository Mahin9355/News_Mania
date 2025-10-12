import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../screens/saved_news_screen.dart';
import '../services/translator_service.dart';

class NewsCard extends StatefulWidget {
  final News news;
  final VoidCallback onTap;
  final bool isBangla;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
    required this.isBangla,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  String? translatedTitle;
  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    if (widget.isBangla) {
      _translateTitle();
    }
  }

  @override
  void didUpdateWidget(covariant NewsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-translate if isBangla toggled
    if (oldWidget.isBangla != widget.isBangla && widget.isBangla) {
      _translateTitle();
    } else if (!widget.isBangla) {
      setState(() {
        translatedTitle = null;
      });
    }
  }

  Future<void> _translateTitle() async {
    setState(() => isTranslating = true);
    final translated =
    await TranslatorService.translateToBangla(widget.news.title);
    setState(() {
      translatedTitle = translated;
      isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle =
    widget.isBangla ? (translatedTitle ?? widget.news.title) : widget.news.title;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isTranslating
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      displayTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.news.publishedAt,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Source: ${widget.news.source}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Save/Delete buttons
                    widget.news.saved
                        ? Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Icon(Icons.save,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "News saved",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            minimumSize: const Size(40, 40),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              savedNews.remove(widget.news);
                              widget.news.saved = false;
                            });
                          },
                          child: const Icon(Icons.delete,
                              size: 26, color: Colors.white),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          savedNews.add(widget.news);
                          widget.news.saved = true;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Save News",
                            style: TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.news.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
