import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../services/notification_service.dart';
import '../../services/supabase_service.dart';
import '../../utils/theme_notifier.dart';
import '../../widgets/product_card.dart';
import 'cart_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    'All',
    'Sneakers',
    'Hoodie',
    'Tshirt',
    'Jacket',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];

  bool _isLoading = true;
  int _unreadCount = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _loadUnreadCount();
  }

  // ── FETCH PRODUCTS ────────────────────────────────────────────────────────
  void _fetchProducts() async {
    try {
      final res = await SupabaseService().getProducts();
      if (mounted) {
        setState(() {
          _allProducts = res;
          _filteredProducts = res;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── LOAD UNREAD COUNT ─────────────────────────────────────────────────────
  Future<void> _loadUnreadCount() async {
    _userId = SupabaseService().getCurrentUserId();
    if (_userId == null) return;
    final count = await NotificationService().getUnreadCount(_userId!);
    if (mounted) setState(() => _unreadCount = count);
  }

  // ── FILTER PRODUCTS ───────────────────────────────────────────────────────
  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final matchesCategory =
            _selectedCategory == 'All' ||
            p.category.toLowerCase() == _selectedCategory.toLowerCase();
        final matchesSearch = p.name.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // FIX UTAMA: Menggunakan select agar TIDAK re-build massal saat animasi drawer berjalan
    final isDark = context.select<ThemeNotifier, bool>(
      (notifier) => notifier.isDark,
    );

    final bgColor = isDark ? const Color(0xFF0F0F10) : const Color(0xFFF7F7F7);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black12;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final inputFill = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return WillPopScope(
      onWillPop: () async => false,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ), // Sedikit dipercepat agar lebih responsif
        curve: Curves.easeOut,
        color: bgColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,

          // ── DRAWER UTK MENU (SETENGAH LAYAR & ANTI-LAG) ──────────────────
          drawer: SizedBox(
            width:
                MediaQuery.of(context).size.width *
                0.60, // 60% Lebar layar (Pas setengah lebih sedikit)
            child: Drawer(
              backgroundColor: bgColor,
              elevation: 0, // Menghilangkan shadow berat bawaan material
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Menu Drawer
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black12, height: 1),
                    const SizedBox(height: 16),

                    // 1. Menu Notification
                    ListTile(
                      leading: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: textColor,
                            size: 26,
                          ),
                          if (_unreadCount > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  _unreadCount > 9 ? '9+' : '$_unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        'Notification',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context); // Tutup drawer dulu
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationPage(),
                          ),
                        );
                        _loadUnreadCount();
                      },
                    ),

                    // 2. Menu Keranjang (Cart)
                    ListTile(
                      leading: Icon(
                        Icons.shopping_bag_outlined,
                        color: textColor,
                        size: 26,
                      ),
                      title: Text(
                        'Cart',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                    ),

                    // 3. Menu Profile
                    ListTile(
                      leading: Icon(
                        Icons.person_outline_rounded,
                        color: textColor,
                        size: 26,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── APPBAR ───────────────────────────────────────────────────────
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 72,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,

            leading: Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.menu_rounded, color: textColor),
                        onPressed: () {
                          // Membuka drawer secara clean tanpa mentrigger lag halaman utama
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'URBANWEAR',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            actions: const [SizedBox(width: 56)],
          ),

          // ── BODY ─────────────────────────────────────────────────────────
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => _fetchProducts(),
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── SEARCH BAR ────────────────────────────────────
                        Container(
                          // Mengubah AnimatedContainer jadi Container biasa untuk kurangi beban GPU saat idle
                          decoration: BoxDecoration(
                            color: inputFill,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black26 : Colors.black12,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            style: TextStyle(color: textColor, fontSize: 14),
                            cursorColor: textColor,
                            onChanged: (val) {
                              _searchQuery = val;
                              _filterProducts();
                            },
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              hintStyle: TextStyle(color: subTextColor),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: subTextColor,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── BANNER ────────────────────────────────────────
                        Container(
                          // Mengubah AnimatedContainer jadi Container biasa agar smooth
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: const Color(0xFFE65100),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE65100,
                                ).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SEASON SALE',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dapatkan Diskon 30%',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gunakan kode promo: URBAN30',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── CATEGORY CHIPS ────────────────────────────────
                        SizedBox(
                          height: 44,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, idx) {
                              final cat = _categories[idx];
                              final isSelected = _selectedCategory == cat;

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ChoiceChip(
                                  avatar: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        )
                                      : null,
                                  label: Text(cat),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  selectedColor: const Color(0xFFE65100),
                                  backgroundColor: cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xFFE65100)
                                          : borderColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedCategory = cat;
                                    });
                                    _filterProducts();
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── PRODUCTS ──────────────────────────────────────
                        _filteredProducts.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'Produk tidak ditemukan',
                                    style: TextStyle(color: subTextColor),
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.68,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, idx) {
                                  return ProductCard(
                                    product: _filteredProducts[idx],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
