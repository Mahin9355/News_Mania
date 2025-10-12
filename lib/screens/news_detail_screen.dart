import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../utils/summarizer.dart';
import '../services/translator_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;
  final bool isBangla;
  const NewsDetailScreen({super.key, required this.news, required this.isBangla});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String? translatedTitle;
  String? translatedContent;
  bool isTranslating = false;
  bool showBangla = false;

  @override
  void initState() {
    super.initState();
    showBangla = widget.isBangla;
    if (showBangla) {
      _translateNews();
    }
  }

  Future<void> _translateNews() async {
    setState(() => isTranslating = true);
    try {
      translatedTitle = await TranslatorService.translateToBangla(widget.news.title);
      translatedContent = await TranslatorService.translateToBangla(widget.news.content);
    } catch (e) {
      print("Translation error: $e");
    }
    setState(() => isTranslating = false);
  }

  void _toggleBangla() {
    setState(() {
      showBangla = !showBangla;
    });
    if (showBangla && (translatedTitle == null || translatedContent == null)) {
      _translateNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle =
    showBangla ? (translatedTitle ?? widget.news.title) : widget.news.title;
    final displayContent =
    showBangla ? (translatedContent ?? widget.news.content) : widget.news.content;

    return Scaffold(
      appBar: AppBar(title: Text(displayTitle)),
      body: isTranslating
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                displayTitle,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.news.publishedAt,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(widget.news.source,
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text(displayContent, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                );

                try {
                  String textToSummarize =
                      "${widget.news.title}\n\n${widget.news.content}";
                  String summary = await summarizeNews(textToSummarize);

                  Navigator.pop(context); // close loader

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Summary"),
                      content: Text(summary),
                      actions: [
                        TextButton(
                          child: const Text("Close"),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Summarize"),
            ),
            const SizedBox(width: 50),
            ElevatedButton(
              onPressed: _toggleBangla,
              child: Text(showBangla ? "English" : "Bangla"),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
