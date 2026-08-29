

// ============================================================
// PROFILE SCREEN
// ============================================================

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _screenHeader('Profile'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE8F5F0),
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Color(0xFF075640),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Ramesh Kumar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Center(
                  child: Text(
                    'Farmer ID: #88432',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _profileOption(
                  Icons.person_outline,
                  'Personal Information',
                ),
                _profileOption(
                  Icons.location_on_outlined,
                  'Farm Details',
                ),
                _profileOption(
                  Icons.settings_outlined,
                  'Settings',
                ),
                _profileOption(
                  Icons.help_outline,
                  'Help & Support',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileOption(
    IconData icon,
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE3E7EA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF075640),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

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