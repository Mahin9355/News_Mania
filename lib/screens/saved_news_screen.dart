import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';
import '../screens/main_screen.dart';

// Dummy saved news list (Later replace with DB or Provider)
List<News> savedNews = [];

class SavedNewsScreen extends StatelessWidget {
  const SavedNewsScreen({super.key});

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
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 100,top: 16),
        itemCount: savedNews.length,
        itemBuilder: (context, index) {
          final news = savedNews[index];
          return NewsCard(
            news: news,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewsDetailScreen(news: news),
                ),
              );
            },
          );
        },
      ),
        floatingActionButton: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(250, 50),
              ),
              onPressed: () {
                // TODO: Summarize logic
              },
              child:
              const Text("Summarize",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}