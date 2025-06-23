import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Petani Muda';
  String _email = 'petani@example.com';
  String _phone = '+62 812 3456 7890';
  String _address = 'Jl. Pertanian No. 123, Desa Makmur';
  bool _notificationsEnabled = true;
  bool _isProfileImageChanged = false;

  void _updateProfile(
    String newName,
    String newEmail,
    String newPhone,
    String newAddress,
  ) {
    setState(() {
      _name = newName;
      _email = newEmail;
      _phone = newPhone;
      _address = newAddress;
    });
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ganti Kata Sandi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Lama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Kata Sandi Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kata sandi berhasil diubah')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isProfileImageChanged = !_isProfileImageChanged;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Foto profil diperbarui')),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _isProfileImageChanged
                              ? const NetworkImage(
                                  'https://example.com/new_avatar.jpg',
                                )
                              : const NetworkImage(
                                  'https://example.com/avatar.jpg',
                                ),
                          child: !_isProfileImageChanged
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 100,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      icon: Icons.person,
                      title: 'Data Pribadi',
                      onTap: () => _showDataPribadiDialog(context),
                    ),
                    const Divider(height: 1),
                    _buildProfileItem(
                      context,
                      icon: Icons.lock,
                      title: 'Keamanan',
                      onTap: _changePassword,
                    ),
                    const Divider(height: 1),
                    _buildProfileItem(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifikasi',
                      onTap: () {
                        setState(() {
                          _notificationsEnabled = !_notificationsEnabled;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _notificationsEnabled
                                  ? 'Notifikasi diaktifkan'
                                  : 'Notifikasi dinonaktifkan',
                            ),
                          ),
                        );
                      },
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    const Divider(height: 1),
                    _buildProfileItem(
                      context,
                      icon: Icons.history,
                      title: 'Riwayat Aktivitas',
                      onTap: () => _showActivityHistory(context),
                    ),
                    const Divider(height: 1),
                    _buildProfileItem(
                      context,
                      icon: Icons.help,
                      title: 'Bantuan',
                      onTap: () => _showHelpDialog(context),
                    ),
                    const Divider(height: 1),
                    _buildProfileItem(
                      context,
                      icon: Icons.info,
                      title: 'Tentang Aplikasi',
                      onTap: () => _showAboutApp(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildFeatureItem(
                      icon: Icons.feedback,
                      title: 'Kirim Masukan',
                      onTap: () => _showFeedbackDialog(context),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showLogoutDialog(context),
                  child: const Text('Keluar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showDataPribadiDialog(BuildContext context) {
    TextEditingController namaController = TextEditingController(text: _name);
    TextEditingController emailController = TextEditingController(text: _email);
    TextEditingController phoneController = TextEditingController(text: _phone);
    TextEditingController addressController = TextEditingController(
      text: _address,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Data Pribadi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateProfile(
                namaController.text,
                emailController.text,
                phoneController.text,
                addressController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data pribadi berhasil diperbarui'),
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bantuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dukungan Pelanggan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text('support@agroapp.com'),
            const SizedBox(height: 15),
            const Text(
              'Pusat Bantuan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text('Telp: 1500-123'),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showFAQScreen(context);
              },
              child: const Text('Lihat FAQ'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda berhasil keluar')),
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showActivityHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Aktivitas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.history, color: Colors.green),
                      title: Text('Aktivitas ${index + 1}'),
                      subtitle: Text('Hari ini, 10:3${index} AM'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.agriculture, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                'AgroApp',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text('Versi 2.1.0', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi pertanian modern untuk membantu petani Indonesia dalam mengelola usaha tani mereka dengan lebih efisien dan produktif.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text('© 2023 AgroApp. Hak Cipta Dilindungi'),
              const SizedBox(height: 10),
              const Text(
                'Dikembangkan oleh:',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const Text('PT Solusi Tani Digital'),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showPrivacyPolicy(context);
                  },
                  child: const Text('Kebijakan Privasi'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kirim Masukan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Masukan Anda',
                border: OutlineInputBorder(),
                hintText: 'Tulis masukan atau laporan masalah...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan isi masukan Anda')),
                );
                return;
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Masukan berhasil dikirim')),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void _showFAQScreen(BuildContext context) {
    final List<Map<String, String>> faqItems = [
      {
        'question': 'Bagaimana cara mengubah foto profil?',
        'answer':
            'Tekan foto profil Anda di halaman profil, lalu pilih gambar dari galeri Anda.',
      },
      {
        'question': 'Bagaimana cara mengubah kata sandi?',
        'answer':
            'Buka menu Keamanan di halaman profil, lalu ikuti petunjuk untuk mengubah kata sandi.',
      },
      {
        'question': 'Apa itu fitur Riwayat Aktivitas?',
        'answer':
            'Fitur ini mencatat semua aktivitas penting Anda dalam aplikasi seperti transaksi, perubahan data, dan lainnya.',
      },
      {
        'question': 'Bagaimana cara menghubungi dukungan pelanggan?',
        'answer':
            'Anda dapat menghubungi kami melalui email di support@agroapp.com atau telepon di 1500-123.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pertanyaan Umum (FAQ)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: faqItems.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(faqItems[index]['question']!),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(faqItems[index]['answer']!),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: const SingleChildScrollView(
          child: Text(
            'Kebijakan Privasi AgroApp\n\n'
            '1. Pengumpulan Data\n'
            'Kami mengumpulkan data pribadi seperti nama, email, dan informasi kontak lainnya yang Anda berikan saat mendaftar atau menggunakan aplikasi.\n\n'
            '2. Penggunaan Data\n'
            'Data digunakan untuk menyediakan layanan, personalisasi pengalaman, dan meningkatkan kualitas aplikasi.\n\n'
            '3. Perlindungan Data\n'
            'Kami menerapkan langkah-langkah keamanan untuk melindungi data Anda dari akses tidak sah atau penyalahgunaan.\n\n'
            '4. Berbagi Data\n'
            'Kami tidak menjual atau membagikan data pribadi Anda kepada pihak ketiga tanpa izin Anda, kecuali diwajibkan oleh hukum.\n\n'
            'Kebijakan ini dapat diperbarui dari waktu ke waktu. Versi terbaru selalu tersedia di aplikasi.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
