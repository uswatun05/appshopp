import 'dart:async';
import 'package:flutter/material.dart';
import 'package:appshopp/screens/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  final List<List<Color>> _gradients = [
    [Color(0xFF6A1B9A), Colors.white],
    [Color(0xFFE040FB), Color(0xFFBA68C8)],
    [Color(0xFFD1C4E9), Color(0xFFF8BBD0)],
  ];

  int _gradientIndex = 0;

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  bool _showText = false;
  int _currentDot = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 
    Future.delayed(const Duration(seconds:6),(){
      if (mounted){
      Navigator.pushReplacement(
        context,
      MaterialPageRoute(builder: (context)=> Home()),
      );
      }
    });

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoController.forward();

    Future.delayed(Duration(milliseconds: 1300), () {
      setState(() {
        _showText = true;
      });
    });

    _timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        _currentDot = (_currentDot + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Widget buildFloatingIcon(IconData icon, Alignment begin, Alignment end) {
    return TweenAnimationBuilder<Alignment>(
      tween: Tween(begin: begin, end: end),
      duration: Duration(seconds: 4),
      curve: Curves.easeInOut,
      builder: (context, alignment, child) {
        return Align(
          alignment: alignment,
          child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.3)),
        );
      },
      onEnd: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: Duration(seconds: 3),
            onEnd: () {
              setState(() {
                _gradientIndex = (_gradientIndex + 1) % _gradients.length;
              });
            },
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradients[_gradientIndex],
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _showText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 800),
                  child: const Text(
                    'Shopping Yuk',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Kaushan',
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                AnimatedOpacity(
                  opacity: _showText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1000),
                  child: const Text(
                    'Temukan outfit yang kamu suka',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.white60,
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
