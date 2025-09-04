import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomemakerHomeScreen extends StatefulWidget {
  const HomemakerHomeScreen({Key? key}) : super(key: key);

  @override
  State<HomemakerHomeScreen> createState() => _HomemakerHomeScreenState();
}

class _HomemakerHomeScreenState extends State<HomemakerHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _imageUrl = '';
  double _price = 0;
  String _vegType = 'Veg';
  String _type = 'Homemaker';
  String _cuisine = 'North Indian';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _loading = true; _error = null; });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Not logged in');
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final homemakerName = userDoc.data()?['name'] ?? '';
      await FirebaseFirestore.instance.collection('meals').add({
        'name': _name,
        'description': _description,
        'imageUrl': _imageUrl,
        'price': _price,
        'vegType': _vegType,
        'type': _type,
        'cuisine': _cuisine,
        'homemakerId': uid,
        'homemakerName': homemakerName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dish added successfully!'),
            backgroundColor: const Color(0xFF004D00), // Emerald
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        _formKey.currentState!.reset();
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Dish',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF004D00), // Brown
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Gold text
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)), // Gold icons
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF8DC), // Cream background
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Decorative header
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D00).withOpacity(0.1), // Emerald light
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: const Color(0xFF004D00)), // Emerald
                    const SizedBox(width: 12),
                    Text(
                      'Share your homemade specialties',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF884513), // Brown
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Dish Name
              _buildFormField(
                label: 'Dish Name',
                icon: Icons.fastfood,
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v ?? '',
              ),

              // Description
              _buildFormField(
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
                onSaved: (v) => _description = v ?? '',
              ),

              // Image URL
              _buildFormField(
                label: 'Image URL',
                icon: Icons.image,
                hintText: 'Paste a direct image URL (should open the image in a new tab)',
                validator: (v) => v == null || v.isEmpty ? 'Enter image URL' : null,
                onSaved: (v) => _imageUrl = v ?? '',
              ),

              // Price
              _buildFormField(
                label: 'Price (₹)',
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter price';
                  final price = double.tryParse(v);
                  if (price == null || price <= 0) return 'Enter valid price';
                  return null;
                },
                onSaved: (v) => _price = double.tryParse(v ?? '') ?? 0,
              ),

              const SizedBox(height: 16),

              // Veg Type Dropdown
              _buildDropdown(
                label: 'Veg Type',
                icon: Icons.eco,
                value: _vegType,
                items: const ['Veg', 'Non-Veg'],
                onChanged: (v) => setState(() => _vegType = v ?? 'Veg'),
              ),

              const SizedBox(height: 16),

              // Dish Type Dropdown
              _buildDropdown(
                label: 'Dish Type',
                icon: Icons.category,
                value: _type,
                items: const ['Homemaker', 'Daily', 'Combo'],
                onChanged: (v) => setState(() => _type = v ?? 'Homemaker'),
              ),

              const SizedBox(height: 16),

              // Cuisine Dropdown
              _buildDropdown(
                label: 'Cuisine',
                icon: Icons.language,
                value: _cuisine,
                items: const [
                  'North Indian',
                  'South Indian',
                  'Chinese',
                  'Italian',
                  'Maharashtrian',
                  'Other'
                ],
                onChanged: (v) => setState(() => _cuisine = v ?? 'North Indian'),
              ),

              const SizedBox(height: 24),

              // Error Message
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D00), // Emerald
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add Dish',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Traditional decorative element
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF884513)), // Brown
          prefixIcon: Icon(icon, color: const Color(0xFF88860B)), // Gold
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: const Color(0xFF88860B)), // Gold
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: const Color(0xFF88860B).withOpacity(0.5)), // Gold
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF004D00), // Emerald
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(color: Colors.black87),
        cursorColor: const Color(0xFF004D00), // Emerald
        validator: validator,
        onSaved: onSaved,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF88860B).withOpacity(0.5), // Gold
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF884513)), // Brown
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF88860B)), // Gold
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Color(0xFF884513)), // Brown
          ),
        )).toList(),
        onChanged: onChanged,
        dropdownColor: const Color(0xFFFFF8DC), // Cream
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF88860B), // Gold
        ),
      ),
    );
  }
}