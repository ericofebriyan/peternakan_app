import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart'; // Pastikan import ini benar

class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    final date = DateTime.tryParse(dateStr);
    return date != null
        ? DateFormat('dd MMM yyyy, HH:mm', 'id').format(date)
        : '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita Pertanian & Peternakan')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: NewsService.getAgriLivestockNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final news = snapshot.data ?? [];
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final item = news[index];
              return Card(
                child: ListTile(
                  title: Text(item['title'] ?? 'No title'),
                  subtitle: Text(formatDate(item['publishedAt'])),
                  onTap: () => _launchURL(item['url']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
