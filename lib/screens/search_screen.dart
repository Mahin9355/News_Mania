import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import '../utils/news_api_service.dart';
import '../utils/summarizer.dart';
import 'news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();

  List<News> results = [];
  bool isLoading = false;
  String errorMessage = "";

  Future<void> _performSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      results = [];
      errorMessage = "";
    });

    try {
      // Expand query with AI
      final expandedQueries = await expandSearchQuery(query);

      List<News> allResults = [];
      for (final q in expandedQueries) {
        final results = await apiService.fetchTopNews(q);
        allResults.addAll(results);
      }
// Optionally deduplicate by title
      final fetched = allResults.toSet().toList();
      setState(() {
        results = fetched;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Search failed: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : results.isEmpty
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
                      NewsDetailScreen(news: results[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}