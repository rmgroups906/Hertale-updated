import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'delivery_address_page.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Decorative header
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
                          'Your Traditional Meal Basket',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF884513), // Brown
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Items list
                  ...cart.items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF88860B).withOpacity(0.2), // Gold
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF88860B).withOpacity(0.3), // Gold
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.meal.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFF6E3C5), // Light cream
                              child: Center(
                                child: Icon(
                                  Icons.fastfood,
                                  color: const Color(0xFF88860B), // Gold
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.meal.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF004D00), // Emerald
                                  ),
                                ),
                                Text(
                                  'Homemade by ${item.meal.homemakerName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.quantity} × ₹${item.meal.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: const Color(0xFF884513), // Brown
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${(item.meal.price * item.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF884513), // Brown
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                  
                  if (cart.items.isEmpty) ...[
                    const SizedBox(height: 100),
                    Icon(
                      Icons.shopping_basket_outlined,
                      size: 60,
                      color: const Color(0xFF88860B).withOpacity(0.5), // Gold
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your basket is empty',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xFF884513), // Brown
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Summary and checkout
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF88860B).withOpacity(0.2), // Gold
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order summary
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6E3C5), // Light cream
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Delivery', '₹${cart.deliveryCharge.toStringAsFixed(0)}'),
                      const Divider(height: 20, thickness: 1),
                      _buildSummaryRow(
                        'Total',
                        '₹${cart.totalPrice.toStringAsFixed(0)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Checkout button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D00), // Emerald
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: cart.items.isEmpty ? null : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DeliveryAddressPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_forward, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Continue to Delivery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Traditional decorative element
                // Add any decorative widgets here if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            color: const Color(0xFF884513), // Brown
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            color: const Color(0xFF004D00), // Emerald
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}