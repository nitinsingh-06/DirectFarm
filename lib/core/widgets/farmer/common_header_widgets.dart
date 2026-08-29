
import 'package:flutter/material.dart';

Widget _screenHeader(String title) {
  return Container(
    width: double.infinity,
    height: 62,
    color: const Color(0xFF075640),
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}