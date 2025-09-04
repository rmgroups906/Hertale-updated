import 'package:flutter/material.dart';
import 'meal_model.dart';
import 'package:provider/provider.dart';
import '../cart/cart_model.dart';

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  const MealDetailPage({Key? key, required this.meal}) : super(key: key);

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: const Color(0xFF004D00), // Brown
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Gold text
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)), // Gold icons
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF8DC), // Cream background
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Meal Image with decorative frame
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF88860B), // Gold
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: meal.imageUrl.isNotEmpty
                  ? Image.network(
                      meal.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 220,
                      color: const Color(0xFF004D00).withOpacity(0.1), // Emerald fallback
                      child: const Icon(Icons.fastfood, size: 60, color: Color(0xFF004D00)),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          
          // Meal Name with decorative underline
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D00), // Emerald
                ),
              ),
              Container(
                height: 3,
                width: 80,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF88860B), // Gold
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            meal.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Homemaker info with traditional icon
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF004D00).withOpacity(0.1), // Emerald light
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF88860B), // Gold
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.face, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prepared with love by',
                        style: TextStyle(fontSize: 20, color: Colors.black54)),
                    Text(meal.homemakerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF884513))), // Brown
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Ingredients section
          const Text('Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D00))), // Emerald
          const SizedBox(height: 8),
          ...meal.ingredients.map((ing) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4, right: 8),
                  child: Icon(Icons.circle, size: 8, color: Color(0xFF88860B)), // Gold
                ),
                Expanded(
                  child: Text(ing,
                      style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
          )).toList(),
          
          const SizedBox(height: 28),
          
          // Quantity and Price section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF88860B).withOpacity(0.3), // Gold
              ),
            ),
            child: Column(
              children: [
                const Text('Select Quantity',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF884513))), // Brown
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle,
                          color: Color(0xFF004D00)), // Emerald
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF88860B)), // Gold
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('$_quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFF004D00)), // Emerald
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Total: ₹${(meal.price * _quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF884513)), // Brown
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Add to Cart button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D00), // Emerald
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(meal, quantity: _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to cart!'),
                    backgroundColor: const Color(0xFF88860B), // Gold
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_basket, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'Add to Cart - ₹${(meal.price * _quantity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          
        ],
      ),
    );
  }
}