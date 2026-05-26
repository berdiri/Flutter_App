import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../services/supabase_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _userId = SupabaseService().getCurrentUserId();
    if (_userId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final list = await NotificationService().getNotifications(_userId!);
    if (mounted) {
      setState(() {
        _notifications = list;
        _isLoading = false;
      });
    }
    // Tandai semua sudah dibaca
    await NotificationService().markAllRead(_userId!);
  }

  Future<void> _clearAll() async {
    if (_userId == null) return;
    await NotificationService().clearAll(_userId!);
    if (mounted) setState(() => _notifications = []);
  }

  // ── ICON PER TIPE ────────────────────────────────────────────────────────
  IconData _iconForType(String type) {
    switch (type) {
      case 'order_confirmed':
        return Icons.check_circle_rounded;
      case 'payment_success':
        return Icons.payment_rounded;
      case 'out_of_delivery':
        return Icons.local_shipping_rounded;
      case 'special_offer':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // ── WARNA PER TIPE ───────────────────────────────────────────────────────
  Color _colorForType(String type) {
    switch (type) {
      case 'order_confirmed':
        return Colors.green;
      case 'payment_success':
        return Colors.blue;
      case 'out_of_delivery':
        return Colors.orange;
      case 'special_offer':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // ── FORMAT WAKTU ─────────────────────────────────────────────────────────
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F10) : const Color(0xFFF7F7F7);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.white54 : Colors.black45;
    final borderColor = isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NOTIFIKASI',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 16,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: isDark
                        ? const Color(0xFF1C1C1E)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Hapus Semua?',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Semua notifikasi akan dihapus secara permanen.',
                      style: TextStyle(color: subText, fontSize: 13),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal', style: TextStyle(color: subText)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearAll();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Hapus Semua',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : Colors.black,
                strokeWidth: 2,
              ),
            )
          : _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 70,
                    color: subText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Notifikasi order & promo akan muncul di sini',
                    style: TextStyle(color: subText, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _notifications.length,
              itemBuilder: (context, idx) {
                final notif = _notifications[idx];
                final color = _colorForType(notif.type);
                final icon = _iconForType(notif.type);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: notif.isRead
                          ? borderColor
                          : color.withOpacity(0.4),
                      width: notif.isRead ? 1 : 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ICON ────────────────────────────────────
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),

                        const SizedBox(width: 14),

                        // ── CONTENT ─────────────────────────────────
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (!notif.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.description,
                                style: TextStyle(
                                  color: subText,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _labelForType(notif.type),
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _timeAgo(notif.createdAt),
                                    style: TextStyle(
                                      color: subText,
                                      fontSize: 10,
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
              },
            ),
    );
  }

  String _labelForType(String type) {
    switch (type) {
      case 'order_confirmed':
        return 'ORDER';
      case 'payment_success':
        return 'PAYMENT';
      case 'out_of_delivery':
        return 'DELIVERY';
      case 'special_offer':
        return 'PROMO';
      default:
        return 'INFO';
    }
  }
}
