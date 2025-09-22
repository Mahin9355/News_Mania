import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsAlertBottomSheet extends StatelessWidget {
  final List<News> allNews;
  const NewsAlertBottomSheet({super.key,required this.allNews});

  @override
  Widget build(BuildContext context) {
    // Show only 4 most recent news
    List<News> latestNews = allNews.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Alerts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: latestNews.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final news = latestNews[index];
                return ListTile(
                leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  news.imageUrl,
                ),
                ),
                  title: Text(news.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(news.publishedAt),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Mark all as read'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add navigation to full notifications screen if needed
                  Navigator.pop(context);
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}