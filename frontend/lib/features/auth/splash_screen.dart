import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hertale/app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late AnimationController _logoController;
  late List<Animation<Offset>> _letterAnimations;
  late Animation<double> _textZoomAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  final String _appName = "HerTale";

  @override
  void initState() {
    super.initState();

    // Controller for the initial letter bounce animation
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Controller for the zoom and logo animations that follow
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Create a staggered bounce animation for each letter
    _letterAnimations = List.generate(_appName.length, (index) {
      final startTime = (index * 100) / 1500;
      final endTime = startTime + (500 / 1500);
      return Tween<Offset>(
        begin: const Offset(0, -2.0), // Start from above
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _textAnimationController,
          curve: Interval(startTime, endTime, curve: Curves.bounceOut),
        ),
      );
    });

    // Animation for the text zooming out and fading
    _textZoomAnimation = Tween<double>(begin: 1.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _textOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Animation for the logo appearing and then dispensing
    _logoScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
          ),
        );

    _logoOpacityAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.0),
            weight: 20,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0),
            weight: 40,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
          ),
        );

    // Chain the animations and navigate when complete
    _textAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _logoController.forward();
      }
    });

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 300), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AuthWrapper(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });

    // Start the first animation
    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E8),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _textAnimationController,
            _logoController,
          ]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // The zooming/fading text
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Transform.scale(
                    scale: _textZoomAnimation.value,
                    child: child,
                  ),
                ),
                // The appearing/dispensing logo
                Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Image.asset(
                      'lib/assets/HerTale.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ],
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_appName.length, (index) {
              return SlideTransition(
                position: _letterAnimations[index],
                child: Text(
                  _appName[index],
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                    color: Color(0xFF004D00),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
