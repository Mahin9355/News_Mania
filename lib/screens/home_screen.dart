import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import '../widgets/news_alert_bottom_sheet.dart';
import '../screens/news_detail_screen.dart';
import '../utils/news_api_service.dart';
import '../utils/summarizer.dart';
import '../screens/search_screen.dart';// Import your summarizeNews function

class HomeScreen extends StatefulWidget {
  const  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<News>> futureNews;

  final List<String> categories = [
    'All',
    'General',
    'World',
    'Nation',
    'Business',
    'Politics',
    'Science',
    'Technology',
    'Sports',
    'Health',
    'Entertainment',
  ];

  String selectedCategory = 'All';
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _fetchNews(selectedCategory);
  }

  void _fetchNews(String category) {
    if (category == 'All') {
      futureNews = apiService.fetchTopNews(null);
    } else {
      futureNews = apiService.fetchTopNews(category.toLowerCase());
    }
    setState(() {});
  }

  Future<void> _summarizeAllNews(BuildContext context) async {
    // Show loader while summarizing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final newsList = await futureNews;

      if (newsList.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No news available to summarize")),
        );
        return;
      }

      // Collect all news content
      String combinedNews = newsList
          .take(5)
          .map((news) => "${news.title}\n${news.content}")
          .join("\n\n");

      String summary = await summarizeNews(
          "Summarize the following news articles briefly into bullet points:\n\n$combinedNews");

      Navigator.pop(context); // close loader

      // Show result in dialog
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
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text('NEWSMANIA'),
        actions: [
          DropdownButton<String>(
            hint: const Text("Select an API"),
            value: selectedValue,
            items: <String>[
              "GNews API",
              "NewsAPI.org",
              "APITube",
              "NewsData.io",
              "newsapi.world",
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              final newsList = await futureNews;
              showModalBottomSheet(
                context: context,
                builder: (_) => NewsAlertBottomSheet(allNews: newsList),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
          ),
         // const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          //const SizedBox(width: 16),
        ],
      ),

      // Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          Container(
            height: 50,
            color: Colors.orange,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                        _fetchNews(selectedCategory);
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // News List
          Expanded(
            child: FutureBuilder<List<News>>(
              future: futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No news available"));
                }

                final filteredNews = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 100),
                  itemCount: filteredNews.length,
                  itemBuilder: (context, index) {
                    return NewsCard(
                      news: filteredNews[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NewsDetailScreen(news: filteredNews[index]),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Summarize Button
      floatingActionButton: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(250, 50),
            ),
            onPressed: () => _summarizeAllNews(context),
            child: const Text(
              "Summarize",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}