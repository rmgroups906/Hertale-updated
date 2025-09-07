// File created by Gemini Code Assist.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hertale/features/auth/login_screen.dart';
import 'package:hertale/features/auth/splash_screen.dart';
import 'package:hertale/tiffin_tales_app/lib/features/meals/home_screen.dart';

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
      home: const SplashScreen(),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          debugPrint('AuthWrapper Error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text(
                'Authentication Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          debugPrint(
            'AuthWrapper: User is logged in. Navigating to HomeScreen.',
          );
          return const HomeScreen();
        } else {
          debugPrint(
            'AuthWrapper: No user logged in. Navigating to LoginScreen.',
          );
          return const LoginScreen();
        }
      },
    );
  }
}
