import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class FinalConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> address;
  final String paymentMethod;
  const FinalConfirmationPage({
    Key? key,
    required this.address,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<FinalConfirmationPage> createState() => _FinalConfirmationPageState();
}

class _FinalConfirmationPageState extends State<FinalConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  String _mobile = '';
  String _email = '';
  bool _loading = false;
  String? _error;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final order = {
        'items': cart.items.map((item) => {
          'mealId': item.meal.id,
          'name': item.meal.name,
          'quantity': item.quantity,
          'price': item.meal.price,
          'homemakerEmail': item.meal.homemakerName,
        }).toList(),
        'total': cart.totalPrice,
        'address': widget.address,
        'paymentMethod': widget.paymentMethod,
        'customerMobile': _mobile,
        'customerEmail': _email,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      await FirebaseFirestore.instance.collection('orders').add(order);
      cart.clearCart();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Order Placed!'),
            content: const Text('Your order has been placed successfully.'),
            backgroundColor: const Color(0xFFFFF8DC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: const Color(0xFF88860B), width: 2),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF004D00)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e, st) {
      setState(() { _error = 'Failed to place order. Please try again.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF004D00), // Brown
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Gold text
        iconTheme: const IconThemeData(color: Color(0xFF88860B)), // Gold icons
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF8DC), // Cream background
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Details Section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D00).withOpacity(0.1), // Emerald light
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.contact_phone, color: const Color(0xFF004D00)), // Emerald
                    const SizedBox(width: 12),
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF884513), // Brown
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contact Form Fields
              _buildFormField(
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.length < 10 ? 'Enter valid mobile number' : null,
                onSaved: (v) => _mobile = v ?? '',
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                onSaved: (v) => _email = v ?? '',
              ),
              
              const SizedBox(height: 24),
              
              // Order Summary Section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D00).withOpacity(0.1), // Emerald light
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_basket, color: const Color(0xFF004D00)), // Emerald
                    const SizedBox(width: 12),
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF884513), // Brown
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Order Items List
              ...cart.items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.2), // Gold
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        item.meal.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF6E3C5), // Light cream
                          child: Center(
                            child: Icon(
                              Icons.fastfood,
                              color: const Color(0xFF88860B), // Gold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    item.meal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF004D00), // Emerald
                    ),
                  ),
                  subtitle: Text(
                    '${item.quantity} × ₹${item.meal.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: const Color(0xFF884513), // Brown
                    ),
                  ),
                  trailing: Text(
                    '₹${(item.meal.price * item.quantity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF884513), // Brown
                    ),
                  ),
                ),
              )).toList(),
              
              const SizedBox(height: 16),
              
              // Order Total
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6E3C5), // Light cream
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF884513), // Brown
                      ),
                    ),
                    Text(
                      '₹${cart.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF004D00), // Emerald
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Payment Method
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6E3C5), // Light cream
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.paymentMethod == 'Cash on Delivery' 
                          ? Icons.money 
                          : Icons.credit_card,
                      color: const Color(0xFF004D00), // Emerald
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Payment: ${widget.paymentMethod}',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF884513), // Brown
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
              
              // Place Order Button
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
                  onPressed: _loading ? null : _placeOrder,
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
                          'Place Order',
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
    );
  }
}