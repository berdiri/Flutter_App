import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../auth/login_page.dart';
import 'help_center_page.dart';
import 'my_orders_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final data = await SupabaseService().getUserProfile();

    if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    }
  }

  // =========================
  // EDIT PROFILE
  // =========================

  void _showEditProfileDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameController = TextEditingController(text: _profile?['name'] ?? '');

    final emailController = TextEditingController(
      text: _profile?['email'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FULL NAME
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),

                  decoration: InputDecoration(
                    hintText: "Full Name",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),

                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),

                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // EMAIL
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),

                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),

                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),

                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () async {
                    await SupabaseService().updateProfile(
                      nameController.text.trim(),
                      emailController.text.trim(),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    _loadProfile();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Profile berhasil diperbarui"),

                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // LOGOUT
  // =========================

  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            'Logout',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14,
            ),
          ),

          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: _logout,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              child: const Text(
                'Logout',
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

  void _logout() async {
    Navigator.pop(context);

    await SupabaseService().logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  // =========================
  // MENU ITEM
  // =========================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,

        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: textColor),

        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: isDark ? Colors.white54 : Colors.black45,
          size: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F10) : const Color(0xFFF7F7F7);

    final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black;

    final subText = isDark ? Colors.grey : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'My Account',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  // PROFILE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: isDark ? Colors.white : Colors.black,

                          child: Icon(
                            Icons.person,
                            size: 55,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          _profile?['name'] ?? 'User',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _profile?['email'] ?? 'email@gmail.com',
                          style: TextStyle(color: subText),
                        ),

                        const SizedBox(height: 22),

                        // EDIT PROFILE BUTTON
                        SizedBox(
                          width: 150,
                          height: 45,

                          child: OutlinedButton(
                            onPressed: _showEditProfileDialog,

                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildMenuItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                      );
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.help_center_rounded,
                    title: 'Help Center',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpCenterPage(),
                        ),
                      );
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: _showLogoutDialog,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE65100),
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        'LOGOUT / KELUAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
