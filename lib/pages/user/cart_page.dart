import 'package:flutter/material.dart';
import '../../models/cart_model.dart';
import '../../services/supabase_service.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> _cartItems = [];

  bool _isLoading = true;

  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // =========================
  // LOAD CART
  // =========================
  void _loadCart() async {
    final res = await SupabaseService().getCartItems();

    double total = 0;

    for (var item in res) {
      if (item.product != null) {
        total += item.product!.price * item.quantity;
      }
    }

    setState(() {
      _cartItems = res;
      _totalPrice = total;
      _isLoading = false;
    });
  }

  // =========================
// REMOVE ITEM DENGAN POPUP KONFIRMASI
// =========================
// =========================
  // REMOVE ITEM DENGAN POPUP KONFIRMASI PREMIUM
  // =========================
  Future<void> _removeItem(int id) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final bool? confirmDelete = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: isDark
            ? const Color(0xFF1C1C1E)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 36,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Hapus Produk",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Produk akan dihapus dari keranjang dan tidak dapat dikembalikan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? Colors.white70
                      : Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Hapus",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  if (confirmDelete != true) return;

  await SupabaseService().removeFromCart(id);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        'Produk berhasil dihapus dari keranjang',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );

  _loadCart();
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F10) : Colors.white;

    final cardColor = isDark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFF5F5F5);

    final textColor = isDark ? Colors.white : Colors.black;

    final subText = isDark ? Colors.white70 : Colors.black54;

    final borderColor = isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgColor,

        title: Text(
          'KERANJANG',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : Colors.black,
              ),
            )
          // =========================
          // EMPTY CART
          // =========================
          : _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.shopping_cart_outlined, size: 90, color: subText),

                  const SizedBox(height: 20),

                  Text(
                    'Keranjang masih kosong',

                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Yuk tambahkan produk favoritmu',

                    style: TextStyle(color: subText, fontSize: 14),
                  ),
                ],
              ),
            )
          // =========================
          // CART CONTENT
          // =========================
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    itemCount: _cartItems.length,

                    itemBuilder: (context, idx) {
                      final item = _cartItems[idx];

                      final product = item.product;

                      if (product == null) {
                        return const SizedBox();
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        margin: const EdgeInsets.only(bottom: 16),

                        decoration: BoxDecoration(
                          color: cardColor,

                          borderRadius: BorderRadius.circular(22),

                          border: Border.all(color: borderColor),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(14),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // =========================
                              // IMAGE
                              // =========================
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),

                                child: Image.asset(
                                  product.imageUrl,

                                  width: 85,
                                  height: 85,

                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // =========================
                              // PRODUCT INFO
                              // =========================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      product.name,

                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,

                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),

                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white10
                                            : Colors.black12,

                                        borderRadius: BorderRadius.circular(30),
                                      ),

                                      child: Text(
                                        'Qty: ${item.quantity}',

                                        style: TextStyle(
                                          color: subText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      'Rp ${product.price.toStringAsFixed(0)}',

                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // =========================
                              // DELETE BUTTON
                              // =========================
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.12),

                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                  ),

                                  onPressed: () => _removeItem(item.id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // =========================
                // BOTTOM CHECKOUT
                // =========================
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: cardColor,

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),

                    border: Border(top: BorderSide(color: borderColor)),
                  ),

                  child: SafeArea(
                    top: false,

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Total Pembayaran',

                              style: TextStyle(color: subText, fontSize: 14),
                            ),

                            Text(
                              'Rp ${_totalPrice.toStringAsFixed(0)}',

                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 55,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,

                              backgroundColor: isDark
                                  ? Colors.white
                                  : Colors.black,

                              foregroundColor: isDark
                                  ? Colors.black
                                  : Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      CheckoutPage(totalPrice: _totalPrice),
                                ),
                              ).then((_) => _loadCart());
                            },

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 20),

                                SizedBox(width: 10),

                                Text(
                                  'LANJUT KE CHECKOUT',

                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,

                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
