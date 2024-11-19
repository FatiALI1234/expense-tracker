
 import 'dart:async';
import 'package:expense_tracker/On%20boarding%20screen.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
// SingleTickerProviderStateMixin is used to provide a single Ticker to an animation
 // controller in a StatefulWidget. It helps manage the lifecycle of the animation by ensuring the animation can be synchronized with the screen's refresh rate.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super. initState();
    _controller = AnimationController(duration: const Duration(seconds: 5),
      vsync: this,)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(_controller);
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 300.0),
          child: Column(
              children: [
                Center(
                  child: ScaleTransition(scale: _animation,
                    child: Image.asset('assets/expense2.png',width: 130,height: 130,),

                  ),
                ),
                Column(
                  children: [
                    Text("Expense tracker", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }
}