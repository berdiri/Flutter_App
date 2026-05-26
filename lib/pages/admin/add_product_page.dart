import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/supabase_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _category = 'Sneakers';
  String _imageUrl =
      'assets/products/shoes1.jpg'; // Menggunakan dummy asset lokal yang telah terdaftar

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final prod = ProductModel(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      imageUrl: _imageUrl,
      category: _category,
    );

    await SupabaseService().addProduct(prod);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambah produk baru')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TAMBAH PRODUK')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Nama Produk'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Data wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(hintText: 'Deskripsi Produk'),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Data wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Harga (Rp)'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Data wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: const Color(0xFF161617),
              decoration: const InputDecoration(hintText: 'Kategori'),
              items: [
                'Sneakers',
                'Hoodie',
                'Tshirt',
                'Jacket',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _imageUrl,
              dropdownColor: const Color(0xFF161617),
              decoration: const InputDecoration(
                hintText: 'Pilih Mock Asset Gambar',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'assets/products/shoes1.jpg',
                  child: Text('Sepatu Sneaker 1'),
                ),
                DropdownMenuItem(
                  value: 'assets/products/shoes2.jpg',
                  child: Text('Sepatu Sneaker 2'),
                ),
                DropdownMenuItem(
                  value: 'assets/products/hoodie1.jpg',
                  child: Text('Hoodie Hitam'),
                ),
                DropdownMenuItem(
                  value: 'assets/products/tshirt1.jpg',
                  child: Text('Kaos Tshirt'),
                ),
                DropdownMenuItem(
                  value: 'assets/products/jacket1.jpg',
                  child: Text('Jaket Bomber'),
                ),
              ],
              onChanged: (v) => setState(() => _imageUrl = v!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: const Text('SIMPAN PRODUK'),
            ),
          ],
        ),
      ),
    );
  }
}
