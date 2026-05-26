// lib/services/notification_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final String id;
  final String
  type; // 'order_confirmed', 'special_offer', 'out_of_delivery', 'payment_success'
  final String title;
  final String description;
  final DateTime createdAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'],
        type: json['type'],
        title: json['title'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        isRead: json['isRead'] ?? false,
      );
}

class NotificationService {
  static const _key = 'urbanwear_notifications';

  // ── AMBIL SEMUA NOTIF ───────────────────────────────────────────────────
  Future<List<NotificationItem>> getNotifications(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_key}_$userId');
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // ── SIMPAN NOTIF ────────────────────────────────────────────────────────
  Future<void> addNotification(String userId, NotificationItem notif) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getNotifications(userId);
    list.insert(0, notif);
    await prefs.setString(
      '${_key}_$userId',
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // ── TANDAI SEMUA SUDAH DIBACA ───────────────────────────────────────────
  Future<void> markAllRead(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getNotifications(userId);
    for (var n in list) {
      n.isRead = true;
    }
    await prefs.setString(
      '${_key}_$userId',
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // ── HITUNG BELUM DIBACA ─────────────────────────────────────────────────
  Future<int> getUnreadCount(String userId) async {
    final list = await getNotifications(userId);
    return list.where((n) => !n.isRead).length;
  }

  // ── HAPUS SEMUA ─────────────────────────────────────────────────────────
  Future<void> clearAll(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_key}_$userId');
  }

  // ── HELPER: TAMBAH NOTIF ORDER CONFIRMED ───────────────────────────────
  Future<void> addOrderConfirmed(
    String userId,
    String orderId,
    double total,
  ) async {
    await addNotification(
      userId,
      NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'order_confirmed',
        title: 'Order Confirmed! 🎉',
        description:
            'Pesanan #$orderId kamu telah dikonfirmasi. Total pembayaran Rp ${total.toStringAsFixed(0)}. Terima kasih sudah berbelanja di UrbanWear!',
        createdAt: DateTime.now(),
      ),
    );
  }

  // ── HELPER: TAMBAH NOTIF PAYMENT SUCCESS ───────────────────────────────
  Future<void> addPaymentSuccess(
    String userId,
    String method,
    double total,
  ) async {
    await addNotification(
      userId,
      NotificationItem(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: 'payment_success',
        title: 'Payment Successful! 💳',
        description:
            'Pembayaran sebesar Rp ${total.toStringAsFixed(0)} melalui $method berhasil diproses. Pesanan kamu sedang disiapkan.',
        createdAt: DateTime.now(),
      ),
    );
  }

  // ── HELPER: TAMBAH NOTIF OUT FOR DELIVERY ──────────────────────────────
  Future<void> addOutOfDelivery(String userId, String orderId) async {
    await addNotification(
      userId,
      NotificationItem(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        type: 'out_of_delivery',
        title: 'Out for Delivery! 🚚',
        description:
            'Pesanan #$orderId kamu sedang dalam perjalanan ke alamat tujuan. Harap pastikan ada seseorang di rumah untuk menerima.',
        createdAt: DateTime.now(),
      ),
    );
  }

  // ── HELPER: TAMBAH SPECIAL OFFER ───────────────────────────────────────
  Future<void> addSpecialOffer(String userId) async {
    await addNotification(
      userId,
      NotificationItem(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        type: 'special_offer',
        title: 'Special Offer Just for You! 🔥',
        description:
            'Dapatkan diskon 30% untuk pembelian berikutnya! Gunakan kode promo URBAN30 saat checkout. Berlaku hingga akhir bulan ini.',
        createdAt: DateTime.now(),
      ),
    );
  }
}
