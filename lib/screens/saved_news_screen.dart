import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';
import '../utils/summarizer.dart';

// Dummy saved news list (replace with DB or Provider later)
List<News> savedNews = [];

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key});

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  bool isBangla = false;

  Future<void> _summarizeAllNews(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (savedNews.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No news available to summarize")),
        );
        return;
      }

      String combinedNews = savedNews
          .take(5)
          .map((news) => "${news.title}\n${news.content}")
          .join("\n\n");

      String summary = await summarizeNews(
          "Summarize the following news articles briefly into bullet points:\n\n$combinedNews");

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Summary of News"),
          content: SingleChildScrollView(child: Text(summary)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Saved News"),
      ),
      body: savedNews.isEmpty
          ? const Center(
        child: Text(
          "No saved news yet!",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 16),
        itemCount: savedNews.length,
        itemBuilder: (context, index) {
          final news = savedNews[index];
          return NewsCard(
            news: news,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NewsDetailScreen(news: news, isBangla: isBangla),
                ),
              );
            },
            isBangla: isBangla,
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () => _summarizeAllNews(context),
                child: const Text(
                  "Summarize",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(width: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(130, 50),
                ),
                onPressed: () {
                  setState(() {
                    isBangla = !isBangla;
                  });
                },
                child: Text(
                  isBangla ? "English" : "Bangla",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
