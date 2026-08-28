import 'package:flutter/material.dart';

class CurrentlyWorkingScreen extends StatefulWidget {
  const CurrentlyWorkingScreen({super.key});

  @override
  State<CurrentlyWorkingScreen> createState() => _CurrentlyWorkingScreenState();
}

class _CurrentlyWorkingScreenState extends State<CurrentlyWorkingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Working On it!',
            style: TextStyle(
              
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F4C3A),
            ),
          ),
        ),
      ),
    );
    
  }
}
