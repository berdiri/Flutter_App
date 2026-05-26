import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // =========================
  // AUTH SERVICES
  // =========================

  Future<AuthResponse> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login gagal. User tidak ditemukan.');
    }

    return response;
  }

  Future<AuthResponse> register(
    String email,
    String password,
    String name,
  ) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    if (response.user == null) {
      throw Exception('Registrasi gagal.');
    }

    return response;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // =========================
  // RESET PASSWORD
  // =========================

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.flutter://reset-password',
    );
  }

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateProfile(String name, String email) async {
    final user = _client.auth.currentUser;

    if (user == null) return;

    // UPDATE AUTH EMAIL
    await _client.auth.updateUser(UserAttributes(email: email));

    // UPDATE USERS TABLE
    await _client
        .from('users')
        .update({'name': name, 'email': email})
        .eq('id', user.id);
  }

  // =========================
  // GET USER ID
  // =========================

  String? getCurrentUserId() {
    return _client.auth.currentUser?.id;
  }

  // =========================
  // GET USER ROLE
  // =========================

  Future<String> getUserRole() async {
    final user = _client.auth.currentUser;

    if (user == null) return 'user';

    final data = await _client
        .from('users')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    // JIKA USER BELUM ADA DI TABLE
    if (data == null) {
      await _client.from('users').upsert({
        'id': user.id,
        'name': user.userMetadata?['name'] ?? 'User',
        'email': user.email ?? '',
        'role': 'user',
      });

      return 'user';
    }

    return data['role'] as String;
  }

  // =========================
  // GET USER PROFILE
  // =========================

  Future<Map<String, dynamic>> getUserProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) return {};

    final data = await _client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data ?? {};
  }

  // =========================
  // PRODUCT SERVICES
  // =========================

  Future<List<ProductModel>> getProducts() async {
    final data = await _client
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return data.map((x) => ProductModel.fromJson(x)).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await _client.from('products').insert(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _client
        .from('products')
        .update(product.toJson())
        .eq('id', product.id!);
  }

  Future<void> deleteProduct(int id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // =========================
  // CART SERVICES
  // =========================

  Future<List<CartModel>> getCartItems() async {
    final userId = getCurrentUserId();

    if (userId == null) return [];

    final data = await _client
        .from('cart')
        .select('*, products(*)')
        .eq('user_id', userId);

    return data.map((x) => CartModel.fromJson(x)).toList();
  }

  Future<void> addToCart(int productId) async {
    final userId = getCurrentUserId();

    if (userId == null) return;

    final existing = await _client
        .from('cart')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId);

    if (existing.isNotEmpty) {
      final int currentQty = existing[0]['quantity'];

      await _client
          .from('cart')
          .update({'quantity': currentQty + 1})
          .eq('id', existing[0]['id']);
    } else {
      await _client.from('cart').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': 1,
      });
    }
  }

  Future<void> removeFromCart(int cartId) async {
    await _client.from('cart').delete().eq('id', cartId);
  }

  Future<void> clearCart() async {
    final userId = getCurrentUserId();

    if (userId == null) return;

    await _client.from('cart').delete().eq('user_id', userId);
  }

  // =========================
  // ORDER SERVICES
  // =========================

  Future<void> createOrder(OrderModel order) async {
    await _client.from('orders').insert(order.toJson());

    await clearCart();
  }

  Future<List<OrderModel>> getUserOrders() async {
    final userId = getCurrentUserId();

    if (userId == null) return [];

    final data = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return data.map((x) => OrderModel.fromJson(x)).toList();
  }
}
