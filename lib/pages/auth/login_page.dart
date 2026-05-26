import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../user/home_page.dart';
import '../admin/admin_dashboard.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // =========================
  // Friendly Error Message
  // =========================

  String _getFriendlyError(String error) {
    if (error.contains('invalid_credentials') ||
        error.contains('Invalid login credentials')) {
      return 'Email or password is incorrect.';
    }

    if (error.contains('email_not_confirmed')) {
      return 'Email has not been confirmed.';
    }

    if (error.contains('too_many_requests') || error.contains('rate limit')) {
      return 'Too many login attempts.';
    }

    if (error.contains('network')) {
      return 'No internet connection.';
    }

    return 'Login failed. Please try again.';
  }

  // =========================
  // LOGIN
  // =========================

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await SupabaseService().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final role = await SupabaseService().getUserRole();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      });
    } catch (e) {
      final msg = _getFriendlyError(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  //=================
                  Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.08),

                          blurRadius: 30,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "SIGN IN",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 32,

                      fontWeight: FontWeight.bold,

                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome back to UrbanWear",

                    style: TextStyle(color: Colors.white54),
                  ),

                  const SizedBox(height: 40),

                  // EMAIL
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextFormField(
                      controller: _emailController,

                      style: const TextStyle(color: Colors.white),

                      decoration: const InputDecoration(
                        hintText: "Email",

                        hintStyle: TextStyle(color: Colors.grey),

                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,

                          color: Colors.white70,
                        ),

                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // PASSWORD
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextFormField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Password",

                        hintStyle: const TextStyle(color: Colors.grey),

                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,

                          color: Colors.white70,
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: Colors.white70,
                          ),
                        ),

                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },

                      child: const Text(
                        "Forgot Password?",

                        style: TextStyle(
                          color: Colors.white70,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.login_rounded),

                                SizedBox(width: 10),

                                Text(
                                  "Sign In",

                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },

                    child: const Text(
                      "Dont have an account? Sign Up",

                      style: TextStyle(color: Colors.white70),
                    ),
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
