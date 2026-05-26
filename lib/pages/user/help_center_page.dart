import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  int? _expandedQuestion;
  int? _expandedCategory;

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _questions = [
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Bagaimana cara melacak pesanan saya?',
      'description':
          'Anda bisa melacak pesanan melalui menu "Pesanan Saya" di halaman utama. '
          'Klik pesanan yang ingin dilacak, lalu pilih "Lacak Pengiriman" untuk '
          'melihat status dan posisi paket secara real-time.',
    },
    {
      'icon': Icons.assignment_return_outlined,
      'title': 'Bagaimana cara mengembalikan pesanan?',
      'description':
          'Pengembalian barang dapat dilakukan dalam 7 hari setelah barang diterima. '
          'Buka menu "Pesanan Saya", pilih pesanan yang ingin dikembalikan, lalu '
          'klik "Ajukan Pengembalian" dan ikuti langkah-langkah yang tersedia.',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'icon': Icons.shopping_bag_outlined,
      'title': 'Pesanan',
      'description':
          'Kelola semua pesanan Anda di sini. Lihat status pesanan, riwayat '
          'transaksi, konfirmasi penerimaan barang, dan berbagai pengaturan '
          'terkait pesanan Anda.',
    },
    {
      'icon': Icons.payment_rounded,
      'title': 'Pembayaran',
      'description':
          'Informasi seputar metode pembayaran yang tersedia, cara menambah '
          'kartu, penggunaan voucher, dan penanganan masalah pembayaran '
          'yang gagal atau pending.',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Pengiriman',
      'description':
          'Temukan informasi tentang estimasi waktu pengiriman, jasa kurir '
          'yang tersedia, biaya ongkir, serta cara mengubah alamat '
          'pengiriman sebelum barang dikirim.',
    },
    {
      'icon': Icons.assignment_return_outlined,
      'title': 'Pengembalian',
      'description':
          'Pelajari syarat dan ketentuan pengembalian barang, cara mengajukan '
          'retur, proses pengembalian dana (refund), dan estimasi waktu '
          'dana kembali ke akun Anda.',
    },
  ];

  List<Map<String, dynamic>> get _filteredQuestions {
    if (_searchQuery.isEmpty) return _questions;

    return _questions.where((item) {
      final title = item['title'].toString().toLowerCase();
      final desc = item['description'].toString().toLowerCase();

      return title.contains(_searchQuery.toLowerCase()) ||
          desc.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;

    return _categories.where((item) {
      final title = item['title'].toString().toLowerCase();
      final desc = item['description'].toString().toLowerCase();

      return title.contains(_searchQuery.toLowerCase()) ||
          desc.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showContactSupport(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.support_agent_rounded, size: 44),
            const SizedBox(height: 12),
            const Text(
              'Hubungi Dukungan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Support team available 24/7 Contact',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _contactRow(
              context,
              Icons.phone_rounded,
              'Telepon / WhatsApp',
              '0821-6154-1016',
            ),
            const SizedBox(height: 12),
            _contactRow(
              context,
              Icons.email_outlined,
              'Email Support',
              'danielsurantasaragih@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('HELP CENTER'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            // SEARCH
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for help topics',
                prefixIcon: const Icon(Icons.search, size: 20),

                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,

                filled: true,
                fillColor: cardColor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),

                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _showContactSupport(context),
                icon: const Icon(Icons.support_agent_rounded, size: 20),
                label: const Text(
                  'Still need help?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // PERTANYAAN
            if (_filteredQuestions.isNotEmpty) ...[
              const Text(
                'Pertanyaan Populer',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              ...List.generate(_filteredQuestions.length, (i) {
                final q = _filteredQuestions[i];

                final isOpen = _expandedQuestion == i;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedQuestion = isOpen ? null : i;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(q['icon'], size: 20),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                q['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            Icon(
                              isOpen
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                            ),
                          ],
                        ),

                        if (isOpen) ...[
                          const SizedBox(height: 10),

                          Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            q['description'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),

            // KATEGORI
            if (_filteredCategories.isNotEmpty) ...[
              const Text(
                'Kategori Bantuan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: List.generate(_filteredCategories.length, (i) {
                  final cat = _filteredCategories[i];

                  final isOpen = _expandedCategory == i;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedCategory = isOpen ? null : i;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: isOpen
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(cat['icon'], size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        cat['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    cat['description'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(cat['icon'], size: 28),
                                const SizedBox(height: 10),
                                Text(
                                  cat['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),
            ],

            // TIDAK ADA HASIL
            if (_filteredQuestions.isEmpty && _filteredCategories.isEmpty) ...[
              const SizedBox(height: 50),

              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Tidak ada hasil ditemukan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Coba gunakan kata kunci lain',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
