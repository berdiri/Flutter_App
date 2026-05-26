import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/notification_service.dart';
import '../../services/supabase_service.dart';

// ─────────────────────────────────────────────
// CHECKOUT PAGE (parent — hanya handle loading & submit)
// ─────────────────────────────────────────────
class CheckoutPage extends StatefulWidget {
  final double totalPrice;
  const CheckoutPage({super.key, required this.totalPrice});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  // Disimpan di parent agar bisa dibaca saat submit
  String _paymentMethod = 'COD';
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userId = SupabaseService().getCurrentUserId();
      final order = OrderModel(
        userId: userId!,
        totalPrice: widget.totalPrice,
        address: _addressController.text.trim(),
        paymentMethod: _paymentMethod,
      );
      await SupabaseService().createOrder(order);

      await NotificationService().addOrderConfirmed(
        userId,
        DateTime.now().millisecondsSinceEpoch.toString().substring(7),
        widget.totalPrice,
      );
      await NotificationService().addPaymentSuccess(
        userId,
        _paymentMethod,
        widget.totalPrice,
      );
      await NotificationService().addOutOfDelivery(
        userId,
        DateTime.now().millisecondsSinceEpoch.toString().substring(7),
      );
      await NotificationService().addSpecialOffer(userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Pesanan berhasil dibuat!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
        Future.delayed(
          const Duration(milliseconds: 600),
          () => Navigator.popUntil(context, (r) => r.isFirst),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuat pesanan: $e',
              style: const TextStyle(
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
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
    final subText = isDark ? Colors.white54 : Colors.black45;
    final borderColor = isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgColor,
        title: Text(
          'CHECKOUT',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // ── Alamat: widget terpisah, tidak rebuild saat payment berubah ──
            Text(
              'Alamat Pengiriman',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 14),
            _AddressField(
              controller: _addressController,
              cardColor: cardColor,
              textColor: textColor,
              subText: subText,
              borderColor: borderColor,
            ),

            const SizedBox(height: 30),

            // ── Payment: widget terpisah, tidak rebuild saat mengetik ──
            Text(
              'Metode Pembayaran',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 14),
            _PaymentSelector(
              initialValue: _paymentMethod,
              onChanged: (val) => _paymentMethod = val, // tanpa setState!
              cardColor: cardColor,
              textColor: textColor,
              subText: subText,
              borderColor: borderColor,
              isDark: isDark,
            ),

            const SizedBox(height: 36),

            // ── Total ──
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: TextStyle(color: subText, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black12,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(Icons.shopping_bag_outlined, color: textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── Button ──
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _isLoading ? null : _placeOrder,
                child: _isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: isDark ? Colors.black : Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'BUAT PESANAN',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET TERPISAH: Address Field
// Tidak pernah rebuild akibat perubahan payment
// ─────────────────────────────────────────────
class _AddressField extends StatelessWidget {
  final TextEditingController controller;
  final Color cardColor;
  final Color textColor;
  final Color subText;
  final Color borderColor;

  const _AddressField({
    required this.controller,
    required this.cardColor,
    required this.textColor,
    required this.subText,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        style: TextStyle(color: textColor, fontSize: 14),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Tuliskan alamat lengkap pengiriman rumah Anda',
          hintStyle: TextStyle(color: subText),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (val) {
          if (val == null || val.trim().isEmpty) return 'Alamat wajib diisi';
          return null;
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET TERPISAH: Payment Selector
// setState di sini TIDAK menyentuh TextFormField
// ─────────────────────────────────────────────
class _PaymentSelector extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final Color cardColor;
  final Color textColor;
  final Color subText;
  final Color borderColor;
  final bool isDark;

  const _PaymentSelector({
    required this.initialValue,
    required this.onChanged,
    required this.cardColor,
    required this.textColor,
    required this.subText,
    required this.borderColor,
    required this.isDark,
  });

  @override
  State<_PaymentSelector> createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<_PaymentSelector> {
  late String _selected;
  bool _showEwallet = false;
  bool _showVA = false;
  bool _showQR = false;
  bool _showRetail = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _select(String val) {
    setState(() => _selected = val);
    widget.onChanged(val); // update parent tanpa setState di parent
  }

  Widget _tile(String value, String label, IconData icon) {
    final isSelected = _selected == value;
    final activeColor = widget.isDark ? Colors.white : Colors.black;
    final selectedBg = widget.isDark ? Colors.white10 : Colors.black12;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _select(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: widget.textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: Radio<String>(
                value: value,
                groupValue: _selected,
                activeColor: activeColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (val) => _select(val!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryHeader(
    String title,
    IconData icon,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Icon(icon, color: widget.subText, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: widget.subText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.subText,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Divider(color: widget.borderColor, thickness: 1, height: 8);

  Widget _expandable(bool isExpanded, List<Widget> children) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      child: isExpanded
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(children: children),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.borderColor),
      ),
      child: Column(
        children: [
          // COD
          _tile('COD', 'COD (Bayar di Tempat)', Icons.local_shipping_outlined),
          _divider(),

          // Transfer Bank
          _tile(
            'Transfer Bank',
            'Transfer Bank',
            Icons.account_balance_outlined,
          ),
          _divider(),

          // E-Wallet
          _categoryHeader(
            'E-Wallet',
            Icons.account_balance_wallet_outlined,
            _showEwallet,
            () => setState(() => _showEwallet = !_showEwallet),
          ),
          _expandable(_showEwallet, [
            _tile('DANA', 'DANA', Icons.wallet),
            _tile('GoPay', 'GoPay', Icons.wallet),
            _tile('OVO', 'OVO', Icons.wallet),
            _tile('ShopeePay', 'ShopeePay', Icons.wallet),
          ]),
          _divider(),

          // Virtual Account
          _categoryHeader(
            'Virtual Account',
            Icons.account_balance_outlined,
            _showVA,
            () => setState(() => _showVA = !_showVA),
          ),
          _expandable(_showVA, [
            _tile('BCA VA', 'BCA Virtual Account', Icons.credit_card_outlined),
            _tile('BNI VA', 'BNI Virtual Account', Icons.credit_card_outlined),
            _tile(
              'Mandiri VA',
              'Mandiri Virtual Account',
              Icons.credit_card_outlined,
            ),
            _tile('BRI VA', 'BRI Virtual Account', Icons.credit_card_outlined),
          ]),
          _divider(),

          // QR Payment
          _categoryHeader(
            'QR Payment',
            Icons.qr_code_outlined,
            _showQR,
            () => setState(() => _showQR = !_showQR),
          ),
          _expandable(_showQR, [
            _tile('QRIS', 'QRIS', Icons.qr_code_2_outlined),
          ]),
          _divider(),

          // Retail Store
          _categoryHeader(
            'Retail Store',
            Icons.storefront_outlined,
            _showRetail,
            () => setState(() => _showRetail = !_showRetail),
          ),
          _expandable(_showRetail, [
            _tile('Indomaret', 'Indomaret', Icons.store_outlined),
            _tile('Alfamart', 'Alfamart', Icons.store_outlined),
          ]),
        ],
      ),
    );
  }
}
