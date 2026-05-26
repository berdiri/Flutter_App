import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/supabase_service.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late String _category;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.name);
    _descCtrl = TextEditingController(text: widget.product.description);
    _priceCtrl = TextEditingController(
      text: widget.product.price.toStringAsFixed(0),
    );
    _category = widget.product.category;
    _imageUrl = widget.product.imageUrl;
  }

  void _update() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProd = ProductModel(
      id: widget.product.id,
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      imageUrl: _imageUrl,
      category: _category,
    );

    await SupabaseService().updateProduct(updatedProd);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EDIT PRODUK')),
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
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _update,
              child: const Text('PERBARUI PRODUK'),
            ),
          ],
        ),
      ),
    );
  }
}
