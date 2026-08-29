
// =======================================================
// SEPARATE SUCCESS ANIMATION CLASS
// =======================================================

import 'package:flutter/material.dart';

class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({super.key});

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Circle scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Overall fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Check icon animation
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.4,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFF8DD500),
            shape: BoxShape.circle,

            // Green glow
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8DD500).withOpacity(0.35),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: ScaleTransition(
              scale: _checkAnimation,
              child: Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF07543F),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: Color(0xFF07543F),
                  size: 18,
                  weight: 700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}