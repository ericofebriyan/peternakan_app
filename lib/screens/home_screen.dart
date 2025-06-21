import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../screens/weather_service.dart';
import 'news_service.dart';
import 'berita_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _weatherData;
  List<Map<String, dynamic>> _news = [];
  bool _loadingWeather = true, _loadingNews = true;

  // Dummy data for livestock summary
  final Map<String, int> _livestockSummary = {
    'Sapi': 42,
    'Ayam': 120,
    'Kambing': 28,
    'Bebek': 65,
    'Domba': 18,
  };

  // Dummy data for today's activities
  final List<Map<String, dynamic>> _todayActivities = [
    {
      'type': 'pakan',
      'title': 'Pemberian Pakan',
      'time': '08:00',
      'status': 'completed',
      'description': 'Pakan untuk semua hewan ternak',
    },
    {
      'type': 'vaksin',
      'title': 'Vaksinasi Sapi',
      'time': '10:30',
      'status': 'in-progress',
      'description': 'Vaksin untuk sapi dewasa',
    },
    {
      'type': 'panen',
      'title': 'Panen Telur Ayam',
      'time': '14:00',
      'status': 'pending',
      'description': 'Panen telur dari kandang A dan B',
    },
    {
      'type': 'pemeriksaan',
      'title': 'Pemeriksaan Kesehatan',
      'time': '16:00',
      'status': 'pending',
      'description': 'Pemeriksaan kambing dan domba',
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null).then((_) {
      fetchWeather();
      fetchLivestockNews();
      setState(() {});
    });
  }

  Future<void> fetchWeather() async {
    try {
      final data = await WeatherService.getWeather('Jakarta');
      setState(() => _weatherData = data);
    } catch (_) {
      setState(() => _weatherData = null);
    } finally {
      setState(() => _loadingWeather = false);
    }
  }

  Future<void> fetchLivestockNews() async {
    try {
      final list = await NewsService.getAgriLivestockNews();
      setState(() => _news = list.take(3).toList());
    } catch (_) {
      setState(() => _news = []);
    } finally {
      setState(() => _loadingNews = false);
    }
  }

  Widget _buildLivestockSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Hewan Ternak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.pets, color: Colors.brown[700]),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _livestockSummary.entries.map((entry) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.value.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: TextStyle(fontSize: 14, color: Colors.brown[600]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Aktivitas Hari Ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.schedule, color: Colors.brown[700]),
            ],
          ),
          const SizedBox(height: 16),
          ..._todayActivities.map((activity) {
            Color statusColor = Colors.grey;
            IconData statusIcon = Icons.access_time;

            switch (activity['status']) {
              case 'completed':
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
                break;
              case 'in-progress':
                statusColor = Colors.orange;
                statusIcon = Icons.autorenew;
                break;
              case 'pending':
                statusColor = Colors.blue;
                statusIcon = Icons.pending;
                break;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getActivityColor(
                        activity['type'],
                      ).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getActivityIcon(activity['type']),
                      color: _getActivityColor(activity['type']),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        activity['time'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(activity['status']),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'pakan':
        return Colors.orange;
      case 'vaksin':
        return Colors.blue;
      case 'panen':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'pakan':
        return Icons.restaurant;
      case 'vaksin':
        return Icons.medical_services;
      case 'panen':
        return Icons.agriculture;
      default:
        return Icons.assignment;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Selesai';
      case 'in-progress':
        return 'Proses';
      case 'pending':
        return 'Menunggu';
      default:
        return '';
    }
  }

  Widget _buildWeatherCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C7744), Color(0xFF5A9367)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _loadingWeather
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _weatherData != null
            ? Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${_weatherData!['icon']}@4x.png',
                    width: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _weatherData!['city'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_weatherData!['weather']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: '${_weatherData!['temp']}'),
                              const TextSpan(
                                text: '°C',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.thermostat,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_weatherData!['humidity']}%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Icon(Icons.air, color: Colors.white, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        '${_weatherData!['wind']} km/h',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Text(
                'Gagal memuat data cuaca',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Handle news tap
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              Image.network(
                article['urlToImage'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.article, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy').format(DateTime.now()),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Peternakan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMEEEEd('id').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PeternakanKu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.brown[700],
        elevation: 0,
        centerTitle: false,
        actions: [
          // IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Livestock Summary Card
            _buildLivestockSummaryCard(),

            const SizedBox(height: 20),

            // Activity Status Card
            _buildActivityStatusCard(),

            const SizedBox(height: 20),

            // Weather Card
            _buildWeatherCard(),

            const SizedBox(height: 24),

            // Section Header Berita
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Berita Peternakan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BeritaScreen()),
                      );
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // News Cards
            if (_loadingNews)
              const Center(child: CircularProgressIndicator())
            else if (_news.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Tidak ada berita peternakan saat ini'),
                ),
              )
            else
              ..._news.map((a) => _buildNewsCard(a)).toList(),
          ],
        ),
      ),
    );
  }
}
