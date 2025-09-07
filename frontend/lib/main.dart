import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:hertale/sample_data.dart';
import 'package:provider/provider.dart';

import 'tiffin_tales_app/lib/features/cart/cart_model.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint(
      'Firebase initialized successfully on ${kIsWeb ? 'Web' : 'Mobile'}.',
    );
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
    // Consider showing an error dialog or a persistent error message to the user
    // if Firebase initialization fails critically.
    return; // Stop execution if Firebase fails to initialize
  }

  // Upload sample dishes only in debug mode to avoid slowing down production app starts.
  if (kDebugMode) {
    try {
      await uploadSampleDishesIfEmpty();
    } catch (e) {
      debugPrint('Error uploading sample dishes: $e');
    }
  }

  runApp(
    ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()),
  );
}
