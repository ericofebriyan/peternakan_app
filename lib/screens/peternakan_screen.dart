import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeternakanScreen extends StatefulWidget {
  const PeternakanScreen({super.key});

  @override
  State<PeternakanScreen> createState() => _PeternakanScreenState();
}

class _PeternakanScreenState extends State<PeternakanScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> dataTernak = []; // Data peternakan kosong

  void _showTernakForm({Map<String, dynamic>? existingTernak}) {
    final isEditMode = existingTernak != null;

    showDialog(
      context: context,
      builder: (context) => TernakFormDialog(
        existingTernak: existingTernak,
        onSave: (newTernak) {
          setState(() {
            if (isEditMode) {
              final index = dataTernak.indexWhere(
                (t) => t['id'] == existingTernak['id'],
              );
              if (index != -1) dataTernak[index] = newTernak;
            } else {
              dataTernak.add(newTernak);
            }
          });
        },
      ),
    );
  }

  // Fungsi untuk menghapus ternak
  void _hapusTernak(String id) {
    setState(() {
      dataTernak.removeWhere((ternak) => ternak['id'] == id);
    });
  }

  Widget _buildSummaryItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
        return Colors.green;
      case 'terindikasi flu':
        return Colors.orange;
      case 'sakit':
        return Colors.red;
      case 'karantina':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getAnimalIcon(String jenis) {
    if (jenis.toLowerCase().contains('sapi')) {
      return Icons.agriculture;
    } else if (jenis.toLowerCase().contains('ayam')) {
      return Icons.egg;
    } else if (jenis.toLowerCase().contains('kambing')) {
      return Icons.pets;
    } else {
      return Icons.eco;
    }
  }

  void tampilkanDetail(Map<String, dynamic> ternak) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Detail ${ternak['jenis']}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  _showTernakForm(existingTernak: ternak);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Data'),
                      content: Text(
                        'Yakin ingin menghapus ${ternak['jenis']}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _hapusTernak(ternak['id']);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Kesehatan'),
                Tab(text: 'Produktivitas'),
                Tab(text: 'Pakan'),
                Tab(text: 'Reproduksi'),
                Tab(text: 'Keuangan'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildOverviewTab(ternak),
              _buildKesehatanTab(ternak),
              _buildProduktivitasTab(ternak),
              _buildPakanTab(ternak),
              _buildReproduksiTab(ternak),
              _buildKeuanganTab(ternak),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> ternak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard('Informasi Dasar', [
            _buildDetailRow('Jumlah Populasi', '${ternak['jumlah']} ekor'),
            _buildDetailRow('Lokasi', ternak['lokasi']),
            _buildDetailRow('Produk', ternak['produk']),
            _buildDetailRow(
              'Produksi',
              '${ternak['produksi']} ${ternak['satuanProduksi']}',
            ),
            _buildDetailRow(
              'Status Kesehatan',
              ternak['kesehatan'],
              valueColor: _getStatusColor(ternak['kesehatan']),
            ),
            _buildDetailRow('Vaksin Terakhir', ternak['vaksin']),
            _buildDetailRow('Catatan', ternak['catatan']),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Distribusi Populasi', [
            _buildDetailRow(
              'Dewasa',
              '${ternak['detail']['umur']['dewasa']} ekor',
            ),
            _buildDetailRow(
              'Remaja',
              '${ternak['detail']['umur']['remaja']} ekor',
            ),
            _buildDetailRow('Anak', '${ternak['detail']['umur']['anak']} ekor'),
            const Divider(),
            _buildDetailRow(
              'Jantan',
              '${ternak['detail']['jenisKelamin']['jantan']} ekor',
            ),
            _buildDetailRow(
              'Betina',
              '${ternak['detail']['jenisKelamin']['betina']} ekor',
            ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Data Genetik', [
            _buildDetailRow('Induk', ternak['detail']['genetik']['induk']),
            _buildDetailRow(
              'Pejantan',
              ternak['detail']['genetik']['pejantan'],
            ),
            _buildDetailRow('Ras', ternak['detail']['genetik']['ras']),
            _buildDetailRow('Catatan', ternak['detail']['genetik']['catatan']),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Lingkungan Kandang', [
            _buildDetailRow(
              'Suhu',
              '${ternak['detail']['lingkungan']['suhu']} °C',
            ),
            _buildDetailRow(
              'Kelembapan',
              '${ternak['detail']['lingkungan']['kelembapan']}%',
            ),
            _buildDetailRow(
              'Kualitas Air',
              ternak['detail']['lingkungan']['kualitasAir'],
            ),
            _buildDetailRow(
              'pH Air',
              '${ternak['detail']['lingkungan']['phAir']}',
            ),
            _buildDetailRow(
              'Pengelolaan Limbah',
              ternak['detail']['lingkungan']['limbah'],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildKesehatanTab(Map<String, dynamic> ternak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard('Status Kesehatan', [
            _buildDetailRow(
              'Status Saat Ini',
              ternak['kesehatan'],
              valueColor: _getStatusColor(ternak['kesehatan']),
            ),
            _buildDetailRow('Vaksin Terakhir', ternak['vaksin']),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Riwayat Kesehatan', [
            if (ternak['detail']['riwayatKesehatan'].isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada riwayat kesehatan'),
              )
            else
              ...ternak['detail']['riwayatKesehatan'].map<Widget>((riwayat) {
                return Column(
                  children: [
                    _buildDetailRow('Tanggal', riwayat['tanggal']),
                    _buildDetailRow('Jenis', riwayat['jenis']),
                    _buildDetailRow('Nama', riwayat['nama']),
                    _buildDetailRow('Dosis', riwayat['dosis']),
                    _buildDetailRow('Keterangan', riwayat['keterangan']),
                    const Divider(),
                  ],
                );
              }).toList(),
            ElevatedButton(
              onPressed: () => _tambahRiwayatKesehatan(ternak),
              child: const Text('Tambah Riwayat'),
            ),
          ]),
        ],
      ),
    );
  }

  void _tambahRiwayatKesehatan(Map<String, dynamic> ternak) {
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController jenisController = TextEditingController();
    final TextEditingController namaController = TextEditingController();
    final TextEditingController dosisController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Riwayat Kesehatan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(tanggalController, 'Tanggal (YYYY-MM-DD)'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jenis'),
                items: ['Vaksinasi', 'Pengobatan', 'Pemeriksaan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => jenisController.text = value!,
              ),
              _buildTextField(namaController, 'Nama Vaksin/Obat'),
              _buildTextField(dosisController, 'Dosis'),
              _buildTextField(keteranganController, 'Keterangan', maxLines: 3),
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
              if (tanggalController.text.isNotEmpty &&
                  jenisController.text.isNotEmpty) {
                setState(() {
                  ternak['detail']['riwayatKesehatan'].add({
                    'tanggal': tanggalController.text,
                    'jenis': jenisController.text,
                    'nama': namaController.text,
                    'dosis': dosisController.text,
                    'keterangan': keteranganController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildProduktivitasTab(Map<String, dynamic> ternak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard('Produktivitas Saat Ini', [
            _buildDetailRow(
              'Produksi',
              '${ternak['produksi']} ${ternak['satuanProduksi']}',
            ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Riwayat Produktivitas', [
            if (ternak['detail']['produktivitas'].isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada data produktivitas'),
              )
            else
              ...ternak['detail']['produktivitas'].map<Widget>((produksi) {
                return Column(
                  children: [
                    _buildDetailRow('Tanggal', produksi['tanggal']),
                    _buildDetailRow('Jenis', produksi['jenis']),
                    _buildDetailRow(
                      'Nilai',
                      '${produksi['nilai']} ${produksi['satuan']}/${produksi['periode']}',
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ElevatedButton(
              onPressed: () => _tambahDataProduktivitas(ternak),
              child: const Text('Tambah Data'),
            ),
          ]),
        ],
      ),
    );
  }

  void _tambahDataProduktivitas(Map<String, dynamic> ternak) {
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController jenisController = TextEditingController();
    final TextEditingController nilaiController = TextEditingController();
    final TextEditingController satuanController = TextEditingController();
    final TextEditingController periodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Data Produktivitas'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(tanggalController, 'Tanggal (YYYY-MM-DD)'),
              _buildTextField(jenisController, 'Jenis Produktivitas'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      nilaiController,
                      'Nilai',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(satuanController, 'Satuan')),
                ],
              ),
              _buildTextField(periodeController, 'Periode (hari/minggu/bulan)'),
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
              if (tanggalController.text.isNotEmpty &&
                  nilaiController.text.isNotEmpty) {
                setState(() {
                  ternak['detail']['produktivitas'].add({
                    'tanggal': tanggalController.text,
                    'jenis': jenisController.text,
                    'nilai': double.parse(nilaiController.text),
                    'satuan': satuanController.text,
                    'periode': periodeController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildPakanTab(Map<String, dynamic> ternak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard('Kebutuhan Pakan', [
            for (int i = 0; i < ternak['pakan']['jenis'].length; i++)
              _buildDetailRow(
                ternak['pakan']['jenis'][i],
                '${ternak['pakan']['jumlah'][i]} ${ternak['pakan']['satuan']}',
              ),
            _buildDetailRow(
              'Total Biaya',
              'Rp${NumberFormat('#,###').format(ternak['pakan']['biaya'])}/${ternak['pakan']['periode']}',
            ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Riwayat Pemberian Pakan', [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Fitur riwayat pemberian pakan akan datang'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Tambah Riwayat'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildReproduksiTab(Map<String, dynamic> ternak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard('Status Reproduksi', [
            _buildDetailRow(
              'Siklus Birahi',
              '${ternak['detail']['reproduksi']['siklusBirahi']} hari',
            ),
            _buildDetailRow(
              'Terakhir Birahi',
              ternak['detail']['reproduksi']['terakhirBirahi'],
            ),
            _buildDetailRow(
              'Terakhir Kawin',
              ternak['detail']['reproduksi']['terakhirKawin'],
            ),
            _buildDetailRow('Status', ternak['detail']['reproduksi']['status']),
            if (ternak['detail']['reproduksi']['perkiraanLahir'] != '-')
              _buildDetailRow(
                'Perkiraan Lahir',
                ternak['detail']['reproduksi']['perkiraanLahir'],
              ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Riwayat Kelahiran', [
            if (ternak['detail']['reproduksi']['riwayatKelahiran'].isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada riwayat kelahiran'),
              )
            else
              ...ternak['detail']['reproduksi']['riwayatKelahiran'].map<Widget>(
                (kelahiran) {
                  return Column(
                    children: [
                      _buildDetailRow('Tanggal', kelahiran['tanggal']),
                      _buildDetailRow(
                        'Jumlah Anak',
                        '${kelahiran['jumlahAnak']} ekor',
                      ),
                      _buildDetailRow('Keterangan', kelahiran['keterangan']),
                      const Divider(),
                    ],
                  );
                },
              ).toList(),
            ElevatedButton(
              onPressed: () => _tambahRiwayatKelahiran(ternak),
              child: const Text('Tambah Riwayat'),
            ),
          ]),
        ],
      ),
    );
  }

  void _tambahRiwayatKelahiran(Map<String, dynamic> ternak) {
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController jumlahController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Riwayat Kelahiran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(tanggalController, 'Tanggal (YYYY-MM-DD)'),
              _buildTextField(jumlahController, 'Jumlah Anak', isNumber: true),
              _buildTextField(keteranganController, 'Keterangan', maxLines: 3),
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
              if (tanggalController.text.isNotEmpty &&
                  jumlahController.text.isNotEmpty) {
                setState(() {
                  ternak['detail']['reproduksi']['riwayatKelahiran'].add({
                    'tanggal': tanggalController.text,
                    'jumlahAnak': int.parse(jumlahController.text),
                    'keterangan': keteranganController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildKeuanganTab(Map<String, dynamic> ternak) {
    double totalPemasukan = 0;
    double totalPengeluaran = 0;

    for (var item in ternak['detail']['keuangan']['pemasukan']) {
      totalPemasukan += item['jumlah'];
    }

    for (var item in ternak['detail']['keuangan']['pengeluaran']) {
      totalPengeluaran += item['jumlah'];
    }

    double profit = totalPemasukan - totalPengeluaran;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailCard('Ringkasan Keuangan', [
            _buildDetailRow(
              'Total Pemasukan',
              'Rp${NumberFormat('#,###').format(totalPemasukan)}',
            ),
            _buildDetailRow(
              'Total Pengeluaran',
              'Rp${NumberFormat('#,###').format(totalPengeluaran)}',
            ),
            _buildDetailRow(
              'Profit',
              'Rp${NumberFormat('#,###').format(profit)}',
              valueColor: profit >= 0 ? Colors.green : Colors.red,
            ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Pemasukan', [
            if (ternak['detail']['keuangan']['pemasukan'].isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada data pemasukan'),
              )
            else
              ...ternak['detail']['keuangan']['pemasukan'].map<Widget>((item) {
                return Column(
                  children: [
                    _buildDetailRow('Tanggal', item['tanggal']),
                    _buildDetailRow('Sumber', item['sumber']),
                    _buildDetailRow(
                      'Jumlah',
                      'Rp${NumberFormat('#,###').format(item['jumlah'])}',
                    ),
                    _buildDetailRow('Keterangan', item['keterangan']),
                    const Divider(),
                  ],
                );
              }).toList(),
            ElevatedButton(
              onPressed: () => _tambahTransaksi(ternak, 'pemasukan'),
              child: const Text('Tambah Pemasukan'),
            ),
          ]),

          const SizedBox(height: 16),
          _buildDetailCard('Pengeluaran', [
            if (ternak['detail']['keuangan']['pengeluaran'].isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada data pengeluaran'),
              )
            else
              ...ternak['detail']['keuangan']['pengeluaran'].map<Widget>((
                item,
              ) {
                return Column(
                  children: [
                    _buildDetailRow('Tanggal', item['tanggal']),
                    _buildDetailRow('Sumber', item['sumber']),
                    _buildDetailRow(
                      'Jumlah',
                      'Rp${NumberFormat('#,###').format(item['jumlah'])}',
                    ),
                    _buildDetailRow('Keterangan', item['keterangan']),
                    const Divider(),
                  ],
                );
              }).toList(),
            ElevatedButton(
              onPressed: () => _tambahTransaksi(ternak, 'pengeluaran'),
              child: const Text('Tambah Pengeluaran'),
            ),
          ]),
        ],
      ),
    );
  }

  void _tambahTransaksi(Map<String, dynamic> ternak, String jenis) {
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController sumberController = TextEditingController();
    final TextEditingController jumlahController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tambah ${jenis == 'pemasukan' ? 'Pemasukan' : 'Pengeluaran'}',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(tanggalController, 'Tanggal (YYYY-MM-DD)'),
              _buildTextField(sumberController, 'Sumber'),
              _buildTextField(jumlahController, 'Jumlah (Rp)', isNumber: true),
              _buildTextField(keteranganController, 'Keterangan', maxLines: 3),
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
              if (tanggalController.text.isNotEmpty &&
                  jumlahController.text.isNotEmpty) {
                setState(() {
                  ternak['detail']['keuangan'][jenis].add({
                    'tanggal': tanggalController.text,
                    'sumber': sumberController.text,
                    'jumlah': double.parse(jumlahController.text),
                    'keterangan': keteranganController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: valueColor)),
          ),
        ],
      ),
    );
  }

  Color _getAnimalColor(String jenis) {
    if (jenis.toLowerCase().contains('sapi')) {
      return Colors.brown;
    } else if (jenis.toLowerCase().contains('ayam')) {
      return Colors.orange;
    } else if (jenis.toLowerCase().contains('kambing')) {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
  }

  Widget _buildDataTernakList() {
    // Calculate total livestock
    int totalTernak = 0;
    for (var ternak in dataTernak) {
      totalTernak += ternak['jumlah'] as int;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    Icons.agriculture,
                    'Total Ternak',
                    '$totalTernak ekor',
                  ),
                  _buildSummaryItem(
                    Icons.attach_money,
                    'Jenis',
                    '${dataTernak.length} jenis',
                  ),
                  _buildSummaryItem(
                    Icons.health_and_safety,
                    'Sehat',
                    '${dataTernak.where((t) => t['kesehatan'].toString().toLowerCase() == 'sehat').length} kelompok',
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: dataTernak.isEmpty
              ? const Center(child: Text('Belum ada data peternakan'))
              : ListView.builder(
                  itemCount: dataTernak.length,
                  itemBuilder: (context, index) {
                    final ternak = dataTernak[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: InkWell(
                        onTap: () => tampilkanDetail(ternak),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(_getAnimalIcon(ternak['jenis'])),
                                      const SizedBox(width: 8),
                                      Text(
                                        ternak['jenis'] as String,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        ternak['kesehatan'],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      ternak['kesehatan'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Populasi: ${ternak['jumlah']} ekor'),
                              Text('Lokasi: ${ternak['lokasi']}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.production_quantity_limits,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Produk: ${ternak['produk']}'),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.timeline, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Produksi: ${ternak['produksi']} ${ternak['satuanProduksi']}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.medical_services, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Vaksin: ${ternak['vaksin']}'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Catatan: ${ternak['catatan']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsScreen() {
    // Calculate analytics data
    int totalTernak = 0;
    double totalProduksi = 0;
    double totalBiayaPakan = 0;
    double totalPendapatan = 0;

    for (var ternak in dataTernak) {
      totalTernak += ternak['jumlah'] as int;
      totalProduksi += ternak['produksi'] as double;
      totalBiayaPakan += ternak['pakan']['biaya'] as double;

      for (var pemasukan in ternak['detail']['keuangan']['pemasukan']) {
        totalPendapatan += pemasukan['jumlah'] as double;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Statistik Peternakan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildAnalyticsCard(
                Icons.agriculture,
                'Total Ternak',
                '$totalTernak ekor',
                Colors.green,
              ),
              _buildAnalyticsCard(
                Icons.production_quantity_limits,
                'Total Produksi',
                NumberFormat('#,###').format(totalProduksi),
                Colors.blue,
              ),
              _buildAnalyticsCard(
                Icons.attach_money,
                'Total Pendapatan',
                'Rp${NumberFormat('#,###').format(totalPendapatan)}',
                Colors.purple,
              ),
              _buildAnalyticsCard(
                Icons.shopping_cart,
                'Total Biaya Pakan',
                'Rp${NumberFormat('#,###').format(totalBiayaPakan)}',
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Distribusi Ternak per Jenis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _buildLivestockTypeChart()),

          const SizedBox(height: 24),
          const Text(
            'Produktivitas per Jenis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _buildProductivityChart()),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 150,
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLivestockTypeChart() {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 50, color: Colors.blue),
            const SizedBox(height: 8),
            Text('Grafik Distribusi Ternak (${dataTernak.length} jenis)'),
            const SizedBox(height: 8),
            ...dataTernak.map(
              (ternak) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Text(ternak['jenis'])),
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            (ternak['jumlah'] as int) /
                            dataTernak.fold(0, (sum, t) => sum + t['jumlah']),
                        backgroundColor: Colors.grey[200],
                        color: _getAnimalColor(ternak['jenis']),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${ternak['jumlah']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityChart() {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.show_chart, size: 50, color: Colors.green),
            const SizedBox(height: 8),
            const Text('Grafik Produktivitas per Jenis Ternak'),
            const SizedBox(height: 8),
            ...dataTernak.map(
              (ternak) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Text(ternak['jenis'])),
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            (ternak['produksi'] as double) /
                            dataTernak.fold(
                              0.0,
                              (sum, t) => sum + t['produksi'],
                            ),
                        backgroundColor: Colors.grey[200],
                        color: _getAnimalColor(ternak['jenis']),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${ternak['produksi']} ${ternak['satuanProduksi']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Peternakan')),
      body: _currentIndex == 0
          ? _buildDataTernakList()
          : _buildAnalyticsScreen(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showTernakForm(),
              child: const Icon(Icons.add),
              tooltip: 'Tambah Data Ternak',
            )
          : null,
    );
  }
}

class TernakFormDialog extends StatefulWidget {
  final Map<String, dynamic>? existingTernak;
  final Function(Map<String, dynamic>) onSave;

  const TernakFormDialog({
    super.key,
    this.existingTernak,
    required this.onSave,
  });

  @override
  State<TernakFormDialog> createState() => _TernakFormDialogState();
}

class _TernakFormDialogState extends State<TernakFormDialog> {
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController produkController = TextEditingController();
  final TextEditingController produksiController = TextEditingController();
  final TextEditingController satuanProduksiController =
      TextEditingController();
  final TextEditingController vaksinController = TextEditingController();
  final TextEditingController kesehatanController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final List<TextEditingController> pakanJenisControllers = [];
  final List<TextEditingController> pakanJumlahControllers = [];
  final TextEditingController pakanSatuanController = TextEditingController();
  final TextEditingController pakanBiayaController = TextEditingController();
  final TextEditingController pakanPeriodeController = TextEditingController();

  final TextEditingController umurDewasaController = TextEditingController();
  final TextEditingController umurRemajaController = TextEditingController();
  final TextEditingController umurAnakController = TextEditingController();
  final TextEditingController jantanController = TextEditingController();
  final TextEditingController betinaController = TextEditingController();

  final TextEditingController indukController = TextEditingController();
  final TextEditingController pejantanController = TextEditingController();
  final TextEditingController rasController = TextEditingController();
  final TextEditingController catatanGenetikController =
      TextEditingController();

  final TextEditingController suhuController = TextEditingController();
  final TextEditingController kelembapanController = TextEditingController();
  final TextEditingController kualitasAirController = TextEditingController();
  final TextEditingController phAirController = TextEditingController();
  final TextEditingController limbahController = TextEditingController();

  final TextEditingController siklusBirahiController = TextEditingController();
  final TextEditingController terakhirBirahiController =
      TextEditingController();
  final TextEditingController terakhirKawinController = TextEditingController();
  final TextEditingController statusReproduksiController =
      TextEditingController();
  final TextEditingController perkiraanLahirController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.existingTernak != null) {
      _isiFormDariData(widget.existingTernak!);
    } else {
      pakanJenisControllers.add(TextEditingController());
      pakanJumlahControllers.add(TextEditingController());
    }
  }

  void _isiFormDariData(Map<String, dynamic> ternak) {
    jenisController.text = ternak['jenis'] ?? '';
    jumlahController.text = ternak['jumlah']?.toString() ?? '';
    lokasiController.text = ternak['lokasi'] ?? '';
    produkController.text = ternak['produk'] ?? '';
    produksiController.text = ternak['produksi']?.toString() ?? '';
    satuanProduksiController.text = ternak['satuanProduksi'] ?? '';
    vaksinController.text = ternak['vaksin'] ?? '';
    kesehatanController.text = ternak['kesehatan'] ?? '';
    catatanController.text = ternak['catatan'] ?? '';

    final pakan = ternak['pakan'] ?? {};
    pakanJenisControllers.clear();
    pakanJumlahControllers.clear();

    final jenisList = pakan['jenis'] as List<dynamic>? ?? [];
    final jumlahList = pakan['jumlah'] as List<dynamic>? ?? [];

    for (int i = 0; i < jenisList.length; i++) {
      pakanJenisControllers.add(
        TextEditingController(text: jenisList[i].toString()),
      );
      if (i < jumlahList.length) {
        pakanJumlahControllers.add(
          TextEditingController(text: jumlahList[i].toString()),
        );
      } else {
        pakanJumlahControllers.add(TextEditingController());
      }
    }

    pakanSatuanController.text = pakan['satuan']?.toString() ?? '';
    pakanBiayaController.text = pakan['biaya']?.toString() ?? '';
    pakanPeriodeController.text = pakan['periode']?.toString() ?? '';

    final detail = ternak['detail'] ?? {};
    final umur = detail['umur'] ?? {};
    umurDewasaController.text = umur['dewasa']?.toString() ?? '';
    umurRemajaController.text = umur['remaja']?.toString() ?? '';
    umurAnakController.text = umur['anak']?.toString() ?? '';

    final jenisKelamin = detail['jenisKelamin'] ?? {};
    jantanController.text = jenisKelamin['jantan']?.toString() ?? '';
    betinaController.text = jenisKelamin['betina']?.toString() ?? '';

    final genetik = detail['genetik'] ?? {};
    indukController.text = genetik['induk']?.toString() ?? '';
    pejantanController.text = genetik['pejantan']?.toString() ?? '';
    rasController.text = genetik['ras']?.toString() ?? '';
    catatanGenetikController.text = genetik['catatan']?.toString() ?? '';

    final lingkungan = detail['lingkungan'] ?? {};
    suhuController.text = lingkungan['suhu']?.toString() ?? '';
    kelembapanController.text = lingkungan['kelembapan']?.toString() ?? '';
    kualitasAirController.text = lingkungan['kualitasAir']?.toString() ?? '';
    phAirController.text = lingkungan['phAir']?.toString() ?? '';
    limbahController.text = lingkungan['limbah']?.toString() ?? '';

    final reproduksi = detail['reproduksi'] ?? {};
    siklusBirahiController.text = reproduksi['siklusBirahi']?.toString() ?? '';
    terakhirBirahiController.text =
        reproduksi['terakhirBirahi']?.toString() ?? '';
    terakhirKawinController.text =
        reproduksi['terakhirKawin']?.toString() ?? '';
    statusReproduksiController.text = reproduksi['status']?.toString() ?? '';
    perkiraanLahirController.text =
        reproduksi['perkiraanLahir']?.toString() ?? '';
  }

  void _simpanData() {
    if (jenisController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jenis ternak wajib diisi')));
      return;
    }

    List<String> jenisPakan = [];
    List<double> jumlahPakan = [];
    for (int i = 0; i < pakanJenisControllers.length; i++) {
      if (pakanJenisControllers[i].text.isNotEmpty &&
          pakanJumlahControllers[i].text.isNotEmpty) {
        jenisPakan.add(pakanJenisControllers[i].text);
        jumlahPakan.add(double.tryParse(pakanJumlahControllers[i].text) ?? 0);
      }
    }

    final newTernak = {
      'id':
          widget.existingTernak?['id'] ??
          'T${DateTime.now().millisecondsSinceEpoch}',
      'jenis': jenisController.text,
      'jumlah': int.tryParse(jumlahController.text) ?? 0,
      'lokasi': lokasiController.text,
      'produk': produkController.text,
      'produksi': double.tryParse(produksiController.text) ?? 0,
      'satuanProduksi': satuanProduksiController.text,
      'vaksin': vaksinController.text,
      'kesehatan': kesehatanController.text,
      'catatan': catatanController.text,
      'pakan': {
        'jenis': jenisPakan,
        'jumlah': jumlahPakan,
        'satuan': pakanSatuanController.text,
        'biaya': double.tryParse(pakanBiayaController.text) ?? 0,
        'periode': pakanPeriodeController.text,
      },
      'detail': {
        'umur': {
          'dewasa': int.tryParse(umurDewasaController.text) ?? 0,
          'remaja': int.tryParse(umurRemajaController.text) ?? 0,
          'anak': int.tryParse(umurAnakController.text) ?? 0,
        },
        'jenisKelamin': {
          'jantan': int.tryParse(jantanController.text) ?? 0,
          'betina': int.tryParse(betinaController.text) ?? 0,
        },
        'riwayatKesehatan': widget.existingTernak != null
            ? widget.existingTernak!['detail']['riwayatKesehatan'] ?? []
            : [],
        'produktivitas': widget.existingTernak != null
            ? widget.existingTernak!['detail']['produktivitas'] ?? []
            : [],
        'genetik': {
          'induk': indukController.text,
          'pejantan': pejantanController.text,
          'ras': rasController.text,
          'catatan': catatanGenetikController.text,
        },
        'lingkungan': {
          'suhu': double.tryParse(suhuController.text) ?? 0,
          'kelembapan': double.tryParse(kelembapanController.text) ?? 0,
          'kualitasAir': kualitasAirController.text,
          'phAir': double.tryParse(phAirController.text) ?? 0,
          'limbah': limbahController.text,
        },
        'reproduksi': {
          'siklusBirahi': int.tryParse(siklusBirahiController.text) ?? 0,
          'terakhirBirahi': terakhirBirahiController.text,
          'terakhirKawin': terakhirKawinController.text,
          'status': statusReproduksiController.text,
          'perkiraanLahir': perkiraanLahirController.text,
          'riwayatKelahiran': widget.existingTernak != null
              ? widget.existingTernak!['detail']['reproduksi']['riwayatKelahiran'] ??
                    []
              : [],
        },
        'keuangan': widget.existingTernak != null
            ? widget.existingTernak!['detail']['keuangan'] ??
                  {'pemasukan': [], 'pengeluaran': []}
            : {'pemasukan': [], 'pengeluaran': []},
      },
    };

    // Panggil callback onSave
    widget.onSave(newTernak);
    Navigator.pop(context);
  }

  void _resetForm() {
    jenisController.clear();
    jumlahController.clear();
    lokasiController.clear();
    produkController.clear();
    produksiController.clear();
    satuanProduksiController.clear();
    vaksinController.clear();
    kesehatanController.clear();
    catatanController.clear();

    for (var controller in pakanJenisControllers) {
      controller.clear();
    }
    for (var controller in pakanJumlahControllers) {
      controller.clear();
    }
    pakanSatuanController.clear();
    pakanBiayaController.clear();
    pakanPeriodeController.clear();

    umurDewasaController.clear();
    umurRemajaController.clear();
    umurAnakController.clear();
    jantanController.clear();
    betinaController.clear();

    indukController.clear();
    pejantanController.clear();
    rasController.clear();
    catatanGenetikController.clear();

    suhuController.clear();
    kelembapanController.clear();
    kualitasAirController.clear();
    phAirController.clear();
    limbahController.clear();

    siklusBirahiController.clear();
    terakhirBirahiController.clear();
    terakhirKawinController.clear();
    statusReproduksiController.clear();
    perkiraanLahirController.clear();

    // Pastikan ada minimal satu input pakan
    if (pakanJenisControllers.isEmpty) {
      pakanJenisControllers.add(TextEditingController());
      pakanJumlahControllers.add(TextEditingController());
    }
  }

  Widget _buildInputSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
        const Divider(),
        ...children,
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
      ),
    );
  }

  List<Widget> _buildPakanInputs() {
    List<Widget> widgets = [];
    for (int i = 0; i < pakanJenisControllers.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: pakanJenisControllers[i],
                  decoration: const InputDecoration(
                    labelText: 'Jenis Pakan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: pakanJumlahControllers[i],
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  if (pakanJenisControllers.length > 1) {
                    setState(() {
                      pakanJenisControllers.removeAt(i);
                      pakanJumlahControllers.removeAt(i);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    widgets.add(
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Tambah Jenis Pakan'),
          onPressed: () {
            setState(() {
              pakanJenisControllers.add(TextEditingController());
              pakanJumlahControllers.add(TextEditingController());
            });
          },
        ),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existingTernak == null
            ? 'Tambah Data Ternak'
            : 'Edit Data Ternak',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInputSection('Informasi Dasar', [
              _buildTextField(jenisController, 'Jenis Ternak'),
              _buildTextField(
                jumlahController,
                'Jumlah Populasi',
                isNumber: true,
              ),
              _buildTextField(lokasiController, 'Lokasi'),
              _buildTextField(produkController, 'Produk'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      produksiController,
                      'Produksi',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      satuanProduksiController,
                      'Satuan Produksi',
                    ),
                  ),
                ],
              ),
              _buildTextField(
                vaksinController,
                'Tanggal Vaksin Terakhir (YYYY-MM-DD)',
              ),
              _buildTextField(kesehatanController, 'Status Kesehatan'),
              _buildTextField(
                catatanController,
                'Catatan Tambahan',
                maxLines: 3,
              ),
            ]),

            _buildInputSection('Data Pakan', [
              ..._buildPakanInputs(),
              _buildTextField(pakanSatuanController, 'Satuan Pakan'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      pakanBiayaController,
                      'Biaya Pakan',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      pakanPeriodeController,
                      'Periode Biaya',
                    ),
                  ),
                ],
              ),
            ]),

            _buildInputSection('Detail Populasi', [
              const Text(
                'Distribusi Umur:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      umurDewasaController,
                      'Dewasa',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      umurRemajaController,
                      'Remaja',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      umurAnakController,
                      'Anak',
                      isNumber: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Jenis Kelamin:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      jantanController,
                      'Jantan',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      betinaController,
                      'Betina',
                      isNumber: true,
                    ),
                  ),
                ],
              ),
            ]),

            _buildInputSection('Data Genetik', [
              _buildTextField(indukController, 'Kode Induk'),
              _buildTextField(pejantanController, 'Kode Pejantan'),
              _buildTextField(rasController, 'Ras'),
              _buildTextField(
                catatanGenetikController,
                'Catatan Genetik',
                maxLines: 2,
              ),
            ]),

            _buildInputSection('Lingkungan Kandang', [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      suhuController,
                      'Suhu (°C)',
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      kelembapanController,
                      'Kelembapan (%)',
                      isNumber: true,
                    ),
                  ),
                ],
              ),
              _buildTextField(kualitasAirController, 'Kualitas Air'),
              _buildTextField(phAirController, 'pH Air', isNumber: true),
              _buildTextField(
                limbahController,
                'Pengelolaan Limbah',
                maxLines: 2,
              ),
            ]),

            _buildInputSection('Data Reproduksi', [
              _buildTextField(
                siklusBirahiController,
                'Siklus Birahi (hari)',
                isNumber: true,
              ),
              _buildTextField(
                terakhirBirahiController,
                'Terakhir Birahi (YYYY-MM-DD)',
              ),
              _buildTextField(
                terakhirKawinController,
                'Terakhir Kawin (YYYY-MM-DD)',
              ),
              _buildTextField(statusReproduksiController, 'Status Reproduksi'),
              _buildTextField(
                perkiraanLahirController,
                'Perkiraan Lahir (YYYY-MM-DD)',
              ),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _resetForm, child: const Text('Reset')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(onPressed: _simpanData, child: const Text('Simpan')),
      ],
    );
  }
}
