import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<UserPreferencesScreen> createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  String _vegType = 'Veg';
  String _cuisine = 'Maharashtrian';
  bool _loading = false;
  String? _error;

  final List<String> _cuisines = [
    'Maharashtrian',
    'Jain',
    'South Indian',
    'North Indian',
    'Diet',
    'Other',
  ];

  Future<void> _savePreferences() async {
    setState(() { _loading = true; _error = null; });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'vegType': _vegType,
        'cuisine': _cuisine,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preferences saved!'),
          backgroundColor: const Color(0xFF004D00), // Emerald
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      setState(() { _error = 'Failed to save preferences.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Preferences',
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
                  Icon(Icons.favorite_border, color: const Color(0xFF004D00)), // Emerald
                  const SizedBox(width: 12),
                  Text(
                    'Tell us about your food preferences',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF884513), // Brown
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Veg/Non-Veg Preference
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF88860B).withOpacity(0.2), // Gold
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004D00), // Emerald
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildFoodTypeOption('Veg', Icons.eco_outlined),
                      const SizedBox(width: 20),
                      _buildFoodTypeOption('Non-Veg', Icons.set_meal_outlined),
                    ],
                  ),
                ],
              ),
            ),

            // Cuisine Preference
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF88860B).withOpacity(0.2), // Gold
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Cuisine',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004D00), // Emerald
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF88860B).withOpacity(0.5), // Gold
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _cuisine,
                      items: _cuisines.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: TextStyle(
                            color: const Color(0xFF884513), // Brown
                          ),
                        ),
                      )).toList(),
                      onChanged: (val) => setState(() => _cuisine = val!),
                      isExpanded: true,
                      underline: const SizedBox(), // Remove default underline
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: const Color(0xFF88860B), // Gold
                      ),
                      dropdownColor: const Color(0xFFFFF8DC), // Cream
                    ),
                  ),
                ],
              ),
            ),

            // Error Message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
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

            // Save Button
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
                onPressed: _loading ? null : _savePreferences,
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
                        'Save Preferences',
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
    );
  }

  Widget _buildFoodTypeOption(String type, IconData icon) {
    final isSelected = _vegType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _vegType = type),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF004D00).withOpacity(0.1) // Emerald light when selected
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF004D00) // Emerald when selected
                  : const Color(0xFF88860B).withOpacity(0.3), // Gold when not selected
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? const Color(0xFF004D00) // Emerald when selected
                    : const Color(0xFF88860B), // Gold when not selected
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF004D00) // Emerald when selected
                      : const Color(0xFF884513), // Brown when not selected
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}