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

  // Dummy data for tips peternakan
  final List<Map<String, dynamic>> _livestockTips = [
    {
      'icon': Icons.water_drop,
      'title': 'Hidrasi Hewan',
      'description':
          'Pastikan hewan ternak selalu memiliki akses air bersih. Ganti air minum minimal 2 kali sehari saat cuaca panas.',
      'color': Colors.blue,
    },
    {
      'icon': Icons.medical_services,
      'title': 'Vaksinasi Rutin',
      'description':
          'Lakukan vaksinasi sesuai jadwal untuk semua jenis ternak. Konsultasikan dengan dokter hewan untuk jadwal yang tepat.',
      'color': Colors.green,
    },
    {
      'icon': Icons.food_bank,
      'title': 'Pakan Berkualitas',
      'description':
          'Berikan pakan dengan nutrisi seimbang sesuai jenis ternak. Tambahkan suplemen vitamin selama musim hujan.',
      'color': Colors.orange,
    },
    {
      'icon': Icons.clean_hands,
      'title': 'Kebersihan Kandang',
      'description':
          'Bersihkan kandang secara rutin untuk mencegah penyakit. Gunakan desinfektan alami seperti kapur untuk lantai kandang.',
      'color': Colors.brown,
    },
    {
      'icon': Icons.thermostat,
      'title': 'Pengendalian Suhu',
      'description':
          'Sediakan tempat teduh untuk ternak saat cuaca panas. Gunakan alas jerami untuk menghangatkan kandang saat malam dingin.',
      'color': Colors.red,
    },
    {
      'icon': Icons.health_and_safety,
      'title': 'Pemantauan Kesehatan',
      'description':
          'Periksa kondisi hewan setiap hari. Segera isolasi hewan yang menunjukkan gejala sakit.',
      'color': Colors.purple,
    },
  ];

  // BARU: Data harga pasar hewan ternak (menggantikan aktivitas hari ini)
  final List<Map<String, dynamic>> _marketPrices = [
    {
      'animal': 'Sapi Potong',
      'price': 65000,
      'unit': 'per kg',
      'trend': 'up', // 'up', 'down', 'stable'
      'change': 2500,
      'icon': Icons.agriculture,
      'color': Colors.brown,
    },
    {
      'animal': 'Ayam Broiler',
      'price': 35000,
      'unit': 'per ekor',
      'trend': 'stable',
      'change': 0,
      'icon': Icons.egg_alt,
      'color': Colors.amber,
    },
    {
      'animal': 'Kambing',
      'price': 125000,
      'unit': 'per kg',
      'trend': 'up',
      'change': 5000,
      'icon': Icons.pets,
      'color': Colors.green,
    },
    {
      'animal': 'Bebek',
      'price': 45000,
      'unit': 'per ekor',
      'trend': 'down',
      'change': 3000,
      'icon': Icons.water,
      'color': Colors.blue,
    },
    {
      'animal': 'Domba',
      'price': 110000,
      'unit': 'per kg',
      'trend': 'up',
      'change': 3500,
      'icon': Icons.grass,
      'color': Colors.grey,
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
      final data = await WeatherService.getWeather('jawa timur');
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

  Widget _buildLivestockTipsCard() {
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
                'Tips Peternakan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.lightbulb, color: Colors.amber[700]),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: _livestockTips.map((tip) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tip['color'].withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: tip['color'].withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: tip['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(tip['icon'], color: tip['color'], size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPricesCard() {
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
                'Harga Pasar Peternakan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.bar_chart, color: Colors.green[700]),
            ],
          ),
          const SizedBox(height: 16),
          ..._marketPrices.map((priceData) {
            Color trendColor = Colors.grey;
            IconData trendIcon = Icons.arrow_right;
            String trendText = 'Stabil';

            switch (priceData['trend']) {
              case 'up':
                trendColor = Colors.green;
                trendIcon = Icons.arrow_upward;
                trendText = 'Naik';
                break;
              case 'down':
                trendColor = Colors.red;
                trendIcon = Icons.arrow_downward;
                trendText = 'Turun';
                break;
              case 'stable':
                trendColor = Colors.grey;
                trendIcon = Icons.arrow_right;
                trendText = 'Stabil';
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
                      color: priceData['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      priceData['icon'],
                      color: priceData['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          priceData['animal'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(priceData['price'])} ${priceData['unit']}',
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
                      Row(
                        children: [
                          Icon(trendIcon, color: trendColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            trendText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: trendColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (priceData['change'] != 0)
                        Text(
                          '${priceData['trend'] == 'down' ? '-' : '+'}${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(priceData['change'])}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: trendColor,
                          ),
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
        actions: [],
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

            _buildLivestockTipsCard(),

            const SizedBox(height: 20),

            _buildMarketPricesCard(),

            const SizedBox(height: 20),

            _buildWeatherCard(),

            const SizedBox(height: 24),

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
