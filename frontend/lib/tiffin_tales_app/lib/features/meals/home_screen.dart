import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user/user_preferences_screen.dart';
import 'meal_model.dart';
import 'meal_detail_page.dart';
import 'homemaker_home_screen.dart';
import '../cart/cart_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _vegType;
  String? _cuisine;
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    setState(() => _loading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      setState(() {
        _vegType = data?['vegType'];
        _cuisine = data?['cuisine'];
        _role = data?['role'];
        _loading = false;
      });
    }
  }

  Future<List<Meal>> _fetchMeals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final prefs = userDoc.data();
    if (prefs == null) return [];
    final query = await FirebaseFirestore.instance
        .collection('meals')
        .where('vegType', isEqualTo: prefs['vegType'])
        .where('cuisine', isEqualTo: prefs['cuisine'])
        .get();
    return query.docs.map((doc) => Meal.fromMap(doc.id, doc.data())).toList();
  }

  Future<List<Meal>> _fetchPopularMeals() async {
    final query = await FirebaseFirestore.instance
        .collection('meals')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
    return query.docs.map((doc) => Meal.fromMap(doc.id, doc.data())).toList();
  }

  void _openPreferences() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserPreferencesScreen()),
    );
    _fetchPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  leading: Padding(
    padding: const EdgeInsets.all(10.0),
    child: ClipOval(
      child: Container(
        color: const Color(0xFF004D00), // Emerald background for the circle
        padding: const EdgeInsets.all(4), // Optional inner padding
        child: Image.asset(
          'lib/assets/HerTale.png',
          width: 30, // Adjust size as needed
          height: 30,
          fit: BoxFit.cover, // Ensures the image fills the circle
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.restaurant,
            color: Color.fromARGB(255, 255, 255, 255), // Gold color for fallback icon
            size: 30,
          ),
        ),
      ),
    ),
  ),
        title: const Text('Tiffin Tales',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF004D00),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          if (_role == 'Homemaker')
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 28),
              tooltip: 'Add Dish',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HomemakerHomeScreen(),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.shopping_basket_outlined, size: 26),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF8DC),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF884513)))
          : FutureBuilder<List<List<Meal>>>(
              future: Future.wait([
                _fetchMeals(),
                _fetchPopularMeals(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF884513)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', 
                      style: const TextStyle(color: Color(0xFF004D00))));
                }
                final results = snapshot.data ?? <List<Meal>>[[], []];
                final List<Meal> meals = results.isNotEmpty ? results[0] : [];
                final List<Meal> popularMeals = results.length > 1 ? results[1] : [];
                final dailyMeals = meals.where((m) => m.type == 'Daily').toList();
                final combos = meals.where((m) => m.type == 'Combo').toList();
                final homemakerMeals = meals.where((m) => m.type == 'Homemaker').toList();
                
                return CustomScrollView(
                  slivers: [
                    // Preferences section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Color(0xFF88860B), width: 1),
                          ),
                          color: const Color(0xFFFFF8DC),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: const Icon(Icons.filter_vintage_rounded, 
                                color: Color(0xFF884513), size: 28),
                            title: Text('Your Preferences', 
                                style: TextStyle(
                                  color: const Color(0xFF004D00),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                )),
                            subtitle: Text('${_vegType ?? "-"}, ${_cuisine ?? "-"}',
                                style: const TextStyle(color: Color(0xFF884513))),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, 
                                  color: Color(0xFF884513), size: 24),
                              onPressed: _openPreferences,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Daily Meals section
                    if (dailyMeals.isNotEmpty)
                      _buildMealSection('Daily Meals', dailyMeals),
                    
                    // Popular Combos section
                    if (combos.isNotEmpty)
                      _buildMealSection('Popular Combos', combos),
                    
                    // Homemaker Listings section
                    if (homemakerMeals.isNotEmpty)
                      _buildMealSection('Local Homemaker Listings', homemakerMeals),
                    
                    // Empty state
                    if (meals.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Image.asset('lib/assets/empty_pot.png', height: 120),
                              const SizedBox(height: 16),
                              const Text('No meals found for your preferences.',
                                  style: TextStyle(
                                    color: Color(0xFF004D00),
                                    fontSize: 16,
                                    fontFamily: 'PlayfairDisplay',
                                  )),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _openPreferences,
                                child: const Text('Update Preferences',
                                    style: TextStyle(
                                      color: Color(0xFF88860B),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Popular Dishes section (always shown)
                    if (popularMeals.isNotEmpty)
                      _buildMealSection('Popular Dishes', popularMeals),
                  ],
                );
              },
            ),
    );
  }

  SliverList _buildMealSection(String title, List<Meal> meals) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(title,
                  style: TextStyle(
                    color: const Color(0xFF004D00),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  )),
            );
          }
          return MealCard(meal: meals[index - 1]);
        },
        childCount: meals.length + 1,
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFF88860B), width: 0.5),
      ),
      color: const Color(0xFFFFF8DC),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MealDetailPage(meal: meal)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meal.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF884513).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          meal.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.food_bank_rounded, 
                                size: 60, color: const Color(0xFF884513).withOpacity(0.5)),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF004D00).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              meal.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF004D00),
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF88860B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₹${meal.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF884513),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                meal.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFF88860B), size: 18),
                  const SizedBox(width: 4),
                  Text('4.8', // Replace with actual rating if available
                      style: TextStyle(color: const Color(0xFF884513))),
                  const Spacer(),
                  Text('${meal.vegType} • ${meal.cuisine}',
                      style: TextStyle(color: const Color(0xFF004D00).withOpacity(0.8))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}