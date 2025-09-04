import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'order_summary_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF004D00), // Emerald
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Gold
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFFFFF8DC), // Cream
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/empty cart.png', height: 150),
                  const SizedBox(height: 20),
                  const Text('Your cart is empty!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF004D00),
                        fontFamily: 'PlayfairDisplay',
                      )),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Explore Meals',
                        style: TextStyle(
                          color: Color(0xFF88860B),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final item = cart.items[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Color(0xFF88860B), width: 0.5),
                        ),
                        color: const Color(0xFFFFF8DC),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFF884513).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.network(
                                item.meal.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Icon(Icons.food_bank_rounded,
                                      size: 30, color: const Color(0xFF884513).withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          title: Text(item.meal.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D00),
                                fontFamily: 'PlayfairDisplay',
                              )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.meal.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline,
                                        color: Color(0xFF884513)),
                                    onPressed: item.quantity > 1
                                        ? () => cart.updateQuantity(item.meal.id, item.quantity - 1)
                                        : null,
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Color(0xFF004D00))),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Color(0xFF884513)),
                                    onPressed: () =>
                                        cart.updateQuantity(item.meal.id, item.quantity + 1),
                                  ),
                                  const Spacer(),
                                  Text('₹${(item.meal.price * item.quantity).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF884513),
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFF004D00), size: 26),
                            onPressed: () => cart.removeFromCart(item.meal.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8DC),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF884513).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(color: const Color(0xFF88860B).withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF004D00),
                                fontFamily: 'PlayfairDisplay',
                              )),
                          Text('₹${cart.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D00),
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Fee:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF004D00),
                              )),
                          Text('₹${cart.deliveryFee.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF004D00),
                              )),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1, color: Color(0xFF88860B)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D00),
                                fontFamily: 'PlayfairDisplay',
                              )),
                          Text('₹${(cart.totalPrice + cart.deliveryFee).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF884513),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D00),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFF88860B), width: 1),
                          ),
                          elevation: 3,
                        ),
                        onPressed: cart.items.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const OrderSummaryPage(),
                                  ),
                                );
                              },
                        child: const Text('Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PlayfairDisplay',
                            )),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Continue Shopping',
                            style: TextStyle(
                              color: Color(0xFF88860B),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}