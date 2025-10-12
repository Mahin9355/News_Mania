import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<News> allNews; // <-- news list from selected API

  const SearchScreen({super.key, required this.allNews});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<News> results = [];

  void _performSearch() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        results.clear();
      });
      return;
    }

    setState(() {
      results = widget.allNews.where((news) {
        final title = news.title?.toLowerCase() ?? "";
        final description = news.content?.toLowerCase() ?? "";
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _performSearch(),
            decoration: InputDecoration(
              hintText: "Search news...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              setState(() {
                results.clear();
              });
            },
          )
        ],
      ),
      body: results.isEmpty
          ? const Center(child: Text("No results"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return NewsCard(
            news: results[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NewsDetailScreen(news: results[index], isBangla: true),
                ),
              );
            },
            isBangla: false
          );
        },
      ),
    );
  }
}