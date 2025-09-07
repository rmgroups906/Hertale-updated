// File created by Gemini Code Assist.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Uploads sample dishes only if the 'meals' collection is empty.
///
/// This function should only be called during development to seed the database.
Future<void> uploadSampleDishesIfEmpty() async {
  final mealsRef = FirebaseFirestore.instance.collection('meals');
  final snapshot = await mealsRef.limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    debugPrint("✅ Meals already exist in Firestore, skipping upload.");
    return;
  }

  debugPrint("⏳ No meals found. Uploading sample dishes...");

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

  debugPrint("✅ Sample dishes uploaded successfully!");
}
