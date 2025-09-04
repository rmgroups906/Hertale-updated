import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'tiffin_tales_app/lib/features/meals/home_screen.dart';
import 'tiffin_tales_app/lib/features/cart/cart_model.dart';
import 'features/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCsAXFbN2vmNjGIirUQiWR8V9YoYtRKzQY",
          authDomain: "tiffin-tales-cd25b.firebaseapp.com",
          projectId: "tiffin-tales-cd25b",
          storageBucket: "tiffin-tales-cd25b.firebasestorage.app",
          messagingSenderId: "335221096174",
          appId: "1:335221096174:web:9a36002823f40686cc7dff",
          measurementId: "G-SRD2JJ5NDJ",
        ),
      );
      debugPrint('Firebase Web initialized successfully.');
    } else {
      await Firebase.initializeApp();
      debugPrint('Firebase Mobile initialized successfully.');
    }
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
    // Consider showing an error dialog or a persistent error message to the user
    // if Firebase initialization fails critically.
    return; // Stop execution if Firebase fails to initialize
  }

  // ⛔️ Run this once to upload sample dishes
  try {
    await uploadSampleDishes();
  } catch (e) {
    debugPrint('Error uploading sample dishes: $e');
    // This might not be critical for app functionality if dishes are already there
    // or if the app can function without them.
  }

  runApp(
    ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()),
  );
}

/// Uploads sample dishes only if collection is empty
Future<void> uploadSampleDishes() async {
  final mealsRef = FirebaseFirestore.instance.collection('meals');
  final snapshot = await mealsRef.limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    print("✅ Meals already exist in Firestore, skipping upload.");
    return;
  }

  final dishes = [
    {
      "name": "Paneer Butter Masala",
      "description": "Creamy tomato-based curry with soft paneer cubes.",
      "imageUrl":
          "https://www.cookwithmanali.com/wp-content/uploads/2019/10/Paneer-Butter-Masala-Restaurant-Style.jpg",
      "price": 120,
      "vegType": "Veg",
      "type": "Daily",
      "cuisine": "North Indian",
      "homemakerId": "demo1",
      "homemakerName": "Aarti Sharma",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Chicken Biryani",
      "description":
          "Aromatic basmati rice cooked with tender chicken and spices.",
      "imageUrl":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2021/12/chicken-biryani-recipe.jpg",
      "price": 180,
      "vegType": "Non-Veg",
      "type": "Combo",
      "cuisine": "South Indian",
      "homemakerId": "demo2",
      "homemakerName": "Ramesh Iyer",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Misal Pav",
      "description":
          "Spicy Maharashtrian curry made with sprouted lentils, served with pav.",
      "imageUrl":
          "https://www.vegrecipesofindia.com/wp-content/uploads/2021/06/misal-pav-1.jpg",
      "price": 80,
      "vegType": "Veg",
      "type": "Homemaker",
      "cuisine": "Maharashtrian",
      "homemakerId": "demo3",
      "homemakerName": "Sunita Patil",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Idli Sambar",
      "description":
          "Soft steamed rice cakes served with tangy sambar and chutney.",
      "imageUrl":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2021/07/idli-recipe.jpg",
      "price": 60,
      "vegType": "Veg",
      "type": "Daily",
      "cuisine": "South Indian",
      "homemakerId": "demo4",
      "homemakerName": "Lakshmi Rao",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Veg Hakka Noodles",
      "description":
          "Stir-fried noodles with fresh vegetables and Indo-Chinese flavors.",
      "imageUrl":
          "https://www.vegrecipesofindia.com/wp-content/uploads/2021/03/hakka-noodles-recipe-1.jpg",
      "price": 100,
      "vegType": "Veg",
      "type": "Combo",
      "cuisine": "Chinese",
      "homemakerId": "demo5",
      "homemakerName": "Priya Singh",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Poha",
      "description":
          "Flattened rice cooked with onions, peas, and mild spices. A light Maharashtrian breakfast.",
      "imageUrl":
          "https://www.vegrecipesofindia.com/wp-content/uploads/2021/06/poha-recipe-1.jpg",
      "price": 50,
      "vegType": "Veg",
      "type": "Homemaker",
      "cuisine": "Maharashtrian",
      "homemakerId": "demo3",
      "homemakerName": "Sunita Patil",
      "createdAt": FieldValue.serverTimestamp(),
    },
    {
      "name": "Margherita Pizza",
      "description":
          "Classic Italian pizza with tomato sauce, mozzarella, and basil.",
      "imageUrl":
          "https://www.simplyrecipes.com/thmb/2QwQn6QwOQwQwQwQwQwQwQwQwQw=/2000x1333/filters:fill(auto,1)/Simply-Recipes-Margherita-Pizza-LEAD-1-1b7e7e7e7e7e4e7e8e7e7e7e7e7e7e7e.jpg",
      "price": 200,
      "vegType": "Veg",
      "type": "Combo",
      "cuisine": "Italian",
      "homemakerId": "demo6",
      "homemakerName": "Giulia Rossi",
      "createdAt": FieldValue.serverTimestamp(),
    },
  ];

  for (final dish in dishes) {
    await mealsRef.add(dish);
  }

  print("✅ Sample dishes uploaded successfully!");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiffin Tales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C4F20)),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF6E3C5),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint(
          'AuthWrapper - ConnectionState: ${snapshot.connectionState}',
        );
        debugPrint('AuthWrapper - Has data: ${snapshot.hasData}');
        debugPrint('AuthWrapper - Has error: ${snapshot.hasError}');
        if (snapshot.hasError) {
          debugPrint('AuthWrapper Error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text(
                'Authentication Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomeScreen();
          debugPrint(
            'AuthWrapper: User is logged in. Navigating to HomeScreen.',
          );
        } else {
          return LoginScreen();
          debugPrint(
            'AuthWrapper: No user logged in. Navigating to LoginScreen.',
          );
        }
      },
    );
  }
}
