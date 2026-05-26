import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/supabase_service.dart';
import '../auth/login_page.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<ProductModel> _products = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // =========================
  // LOAD PRODUCTS
  // =========================
  void _loadProducts() async {
    setState(() => _isLoading = true);

    final res = await SupabaseService().getProducts();

    setState(() {
      _products = res;
      _isLoading = false;
    });
  }

  // =========================
  // DELETE PRODUCT
  // =========================
  void _deleteProduct(int id) async {
    await SupabaseService().deleteProduct(id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Produk berhasil dihapus'),

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

      _loadProducts();
    }
  }

  // =========================
  // DELETE POPUP
  // =========================
  void _showDeleteDialog(ProductModel product) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: const Text(
            'Hapus Produk',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          content: Text(
            'Anda ingin menghapus product ini?',

            style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          ),

          actions: [
            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'CANCEL',

                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // DELETE
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                _deleteProduct(product.id!);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: const Text(
                'HAPUS',

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // LOGOUT POPUP
  // =========================
  void _showLogoutDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          content: Text(
            'Yakin ingin logout?',

            style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'CANCEL',

                style: TextStyle(color: Colors.white70),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await SupabaseService().logout();

                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (r) => false,
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: const Text(
                'LOGOUT',

                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),

      // =========================
      // APPBAR
      // =========================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        centerTitle: true,

        title: const Text(
          'ADMIN PANEL',

          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),

            onPressed: _showLogoutDialog,
          ),
        ],
      ),

      // =========================
      // FLOATING BUTTON
      // =========================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,

        elevation: 2,

        child: const Icon(Icons.add, color: Colors.black),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          ).then((_) => _loadProducts());
        },
      ),

      // =========================
      // BODY
      // =========================
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _products.isEmpty
          ? const Center(
              child: Text(
                'Belum ada produk',

                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),

              itemCount: _products.length,

              itemBuilder: (context, index) {
                final prod = _products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: Colors.white10),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      children: [
                        // IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),

                          child: Image.asset(
                            prod.imageUrl,

                            width: 70,
                            height: 70,

                            fit: BoxFit.cover,

                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,

                              color: Colors.grey.shade800,

                              child: const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // PRODUCT INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                prod.name,

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Rp ${prod.price.toStringAsFixed(0)}',

                                style: TextStyle(
                                  color: Colors.grey.shade400,

                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white10,

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  prod.category,

                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ACTION BUTTONS
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.12),

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditProductPage(product: prod),
                                    ),
                                  ).then((_) => _loadProducts());
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.12),

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),

                                onPressed: () => _showDeleteDialog(prod),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
