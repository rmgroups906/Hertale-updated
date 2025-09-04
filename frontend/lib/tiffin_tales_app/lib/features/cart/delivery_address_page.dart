import 'package:flutter/material.dart';
import 'payment_method_page.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _address = '';
  String _city = '';
  String _pincode = '';

  void _proceed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final address = {
        'name': _name,
        'phone': _phone,
        'address': _address,
        'city': _city,
        'pincode': _pincode,
      };
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentMethodPage(address: address),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Address',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative header
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF004D00).withOpacity(0.1), // Emerald light
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: const Color(0xFF004D00)), // Emerald
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Where should we deliver your homemade meal?',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF884513), // Brown
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Address Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                    onSaved: (v) => _name = v ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.length < 10 ? 'Enter valid phone number' : null,
                    onSaved: (v) => _phone = v ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Full Address',
                    icon: Icons.home_outlined,
                    maxLines: 3,
                    validator: (v) => v == null || v.isEmpty ? 'Enter address' : null,
                    onSaved: (v) => _address = v ?? '',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildFormField(
                          label: 'City',
                          icon: Icons.location_city_outlined,
                          validator: (v) => v == null || v.isEmpty ? 'Enter city' : null,
                          onSaved: (v) => _city = v ?? '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'Pincode',
                          icon: Icons.numbers_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.length < 5 ? 'Enter valid pincode' : null,
                          onSaved: (v) => _pincode = v ?? '',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Proceed Button
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
                      onPressed: _proceed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.arrow_forward, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Traditional decorative element
                  
                ],
              ),
            ),
          ],
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
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF884513)), // Brown
        prefixIcon: Icon(icon, color: const Color(0xFF88860B)), // Gold
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
    );
  }
}