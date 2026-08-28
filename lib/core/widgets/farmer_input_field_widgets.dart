
import 'package:flutter/material.dart';



//   CUSTOM INPUT FIELD // FOR FARMER REGISTER PAGE

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
  });

  static const Color primaryGreen =
      Color(0xFF7CD000);

  static const Color borderColor =
      Color(0xFFE2E5E8);

  static const Color hintColor =
      Color(0xFF969DA7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,

      child: TextFormField(
        controller: controller,

        keyboardType: keyboardType,

        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF303640),
        ),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(
            fontSize: 9,
            color: hintColor,
          ),

          // LEFT ICON
          prefixIcon: Icon(
            icon,
            size: 15,
            color: const Color(0xFF818995),
          ),

          prefixIconConstraints:
              const BoxConstraints(
            minWidth: 38,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),

          filled: true,
          fillColor: Colors.white,

          // NORMAL BORDER
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(7),

            borderSide: const BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),

          // FOCUSED BORDER
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(7),

            borderSide: const BorderSide(
              color: primaryGreen,
              width: 1.2,
            ),
          ),

          // ERROR BORDER
          errorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(7),

            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),

          focusedErrorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(7),

            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}
