
import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 98,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEFFFF7)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF82D000)
                : const Color(0xFFE1E3E5),
            width: selected ? 1.8 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- TEXT ----------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF075B48),
                    ),
                  ),

                  const SizedBox(height: 13),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.3,
                      color: Color(0xFF7A8589),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- ICON SELECTOR ----------------
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? const Color(0xFF82D000)
                    : const Color(0xFFF5F6F7),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected
                    ? const Color(0xFF075B48)
                    : const Color(0xFF7A8589),
              ),
            ),
          ],
        ),
      ),
    );
  }
}