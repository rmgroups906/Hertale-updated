import 'package:flutter/material.dart';
import 'final_confirmation_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final Map<String, dynamic> address;
  const PaymentMethodPage({Key? key, required this.address}) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? _selectedMethod;

  void _proceed() {
    if (_selectedMethod == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FinalConfirmationPage(
          address: widget.address,
          paymentMethod: _selectedMethod!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icon(Icons.payment, color: const Color(0xFF004D00)), // Emerald
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose how you would like to pay',
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

            // Payment Options
            _buildPaymentOption(
              title: 'Cash on Delivery',
              subtitle: 'Pay when you receive your order',
              icon: Icons.money,
              value: 'Cash on Delivery',
              color: const Color(0xFF88860B), // Gold
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              title: 'Online Payment',
              subtitle: 'Pay securely with UPI/Cards',
              icon: Icons.credit_card,
              value: 'Online Payment',
              color: const Color(0xFF004D00), // Emerald
              
            ),

            const SizedBox(height: 32),

            // Continue Button
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
                onPressed: _selectedMethod == null ? null : _proceed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_forward, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Continue to Confirmation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

           
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required Color color,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : () => setState(() => _selectedMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedMethod == value
                ? color
                : const Color(0xFF88860B).withOpacity(0.3), // Gold
            width: _selectedMethod == value ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(disabled ? 0.3 : 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: disabled ? color.withOpacity(0.5) : color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: disabled ? Colors.grey : const Color(0xFF884513), // Brown
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: disabled ? Colors.grey : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedMethod,
              onChanged: disabled ? null : (v) => setState(() => _selectedMethod = v),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}