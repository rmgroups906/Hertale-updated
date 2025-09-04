import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F4E8), // Light cream
              Color(0xFFF1E8D0), // Warmer cream
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with decorative frame
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF8F4E8),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF884513).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xFF88860B), // Gold
                    width: 3,
                  ),
                ),
                child: Image.asset(
                  'lib/assets/HerTale.png',
                  width: 125,
                  height: 125,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),

              // App name with gold to emerald gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF88860B), // Gold
                    Color(0xFF004D00), // Emerald
                  ],
                  stops: [0.3, 0.7],
                ).createShader(bounds),
                child: const Text(
                  'HerTale',
                  style: TextStyle(
                    fontSize: 42,
                    color: Color(0xFF004D00),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily:
                        'PlayfairDisplay', // Add this font to your project
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tagline with decorative elements
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF884513),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'EVERY MEAL TELLS HER STORY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF884513), // Deep brown
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF884513),
                    size: 18,
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Traditional pattern decoration (add your asset)
              
            ],
          ),
        ),
      ),
    );
  }
}
