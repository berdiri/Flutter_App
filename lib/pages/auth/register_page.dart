import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // =========================
  // Friendly Error Message
  // =========================
  String _getFriendlyError(String error) {
    if (error.contains('User already registered')) {
      return 'Email is already registered.';
    }

    if (error.contains('Password should be at least')) {
      return 'Password must be at least 6 characters.';
    }

    if (error.contains('Invalid email')) {
      return 'Invalid email format.';
    }

    if (error.contains('network') || error.contains('SocketException')) {
      return 'No internet connection.';
    }

    return 'Registration failed. Please try again.';
  }

  // =========================
  // REGISTER
  // =========================
  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    // =========================
    // Password Confirmation
    // =========================
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Confirm password does not match.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      if (!mounted) return;

      // =========================
      // SUCCESS NOTIFICATION
      // =========================
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Registration successful!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    } catch (e) {
      final friendlyMessage = _getFriendlyError(e.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              friendlyMessage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

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
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // =========================
                  // LOGO
                  // =========================
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
                          spreadRadius: 1,
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

                  // =========================
                  // TITLE
                  // =========================
                  const Text(
                    'SIGN UP',

                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Create your UrbanWear account',

                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // =========================
                  // NAME FIELD
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),

                      border: Border.all(color: Colors.white10),
                    ),

                    child: TextFormField(
                      controller: _nameController,

                      style: const TextStyle(color: Colors.white),

                      decoration: const InputDecoration(
                        hintText: 'Full Name',

                        hintStyle: TextStyle(color: Colors.grey),

                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white70,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                      ),

                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Full name cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // EMAIL FIELD
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),

                      border: Border.all(color: Colors.white10),
                    ),

                    child: TextFormField(
                      controller: _emailController,

                      keyboardType: TextInputType.emailAddress,

                      style: const TextStyle(color: Colors.white),

                      decoration: const InputDecoration(
                        hintText: 'Email',

                        hintStyle: TextStyle(color: Colors.grey),

                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white70,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                      ),

                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // PASSWORD FIELD
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),

                      border: Border.all(color: Colors.white10),
                    ),

                    child: TextFormField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: 'Password',

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
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: Colors.white70,
                          ),
                        ),

                        border: InputBorder.none,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                      ),

                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // CONFIRM PASSWORD FIELD
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(30),

                      border: Border.all(color: Colors.white10),
                    ),

                    child: TextFormField(
                      controller: _confirmPasswordController,

                      obscureText: _obscureConfirmPassword,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: 'Confirm Password',

                        hintStyle: const TextStyle(color: Colors.grey),

                        prefixIcon: const Icon(
                          Icons.lock_reset_rounded,
                          color: Colors.white70,
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },

                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: Colors.white70,
                          ),
                        ),

                        border: InputBorder.none,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 20,
                        ),
                      ),

                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Confirm password is required';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // REGISTER BUTTON
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,

                      style: ElevatedButton.styleFrom(
                        elevation: 0,

                        backgroundColor: Colors.white,

                        foregroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,

                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.app_registration_rounded, size: 20),

                                SizedBox(width: 10),

                                Text(
                                  'SIGN UP',

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =========================
                  // LOGIN BUTTON
                  // =========================
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },

                    child: const Text(
                      'Already have an account? Sign In Now',

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
