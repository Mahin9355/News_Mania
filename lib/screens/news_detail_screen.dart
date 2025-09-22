import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../screens/main_screen.dart';
import '../utils/summarizer.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  String summarize(String text) {
    List<String> sentences = text.split('.');
    if (sentences.length <= 2) return text;
    return "${sentences.first}. ${sentences[sentences.length ~/ 2]}. ${sentences.last}.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(news.title)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40),
              ),
              const SizedBox(height: 12),
              Text(news.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(news.publishedAt, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(news.source, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text(news.content, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16,left: 16,right: 16),
        child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              String textToSummarize = "${news.title}\n\n${news.content}";
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
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}