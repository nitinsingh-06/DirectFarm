
import 'package:flutter/material.dart';


// ====================================================================
// CROP SELECTOR
// ====================================================================


class CropSelector extends StatelessWidget {
  final List<String> crops;
  final Set<String> selectedCrops;
  final ValueChanged<Set<String>> onChanged;

  const CropSelector({
    super.key,
    required this.crops,
    required this.selectedCrops,
    required this.onChanged,
  });

  static const Color darkGreen =
      Color(0xFF155B4B);

  static const Color borderColor =
      Color(0xFFE2E5E8);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,

      children: crops.map((crop) {

        final bool isSelected =
            selectedCrops.contains(crop);

        return GestureDetector(

          onTap: () {

            // Make a copy so we don't
            // directly modify the original Set.
            final Set<String> updated =
                Set<String>.from(selectedCrops);

            // ======================================================
            // OTHER
            // ======================================================

            if (crop == 'Other') {

              if (isSelected) {

                // If Other is already selected,
                // tapping again removes it.

                updated.remove('Other');

              } else {

                // Other is exclusive.
                // Remove all other crops.

                updated
                  ..clear()
                  ..add('Other');
              }
            }

            // ======================================================
            // NORMAL CROPS
            // ======================================================

            else {

              // If Other was selected,
              // remove Other first.

              updated.remove('Other');

              if (isSelected) {

                // Remove this crop.

                updated.remove(crop);

              } else {

                // Add this crop.

                updated.add(crop);
              }
            }

            onChanged(updated);
          },

          child: AnimatedContainer(

            duration:
                const Duration(milliseconds: 150),
            
            height: 20,
            width: 50,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
            ),

            decoration: BoxDecoration(

              color: isSelected
                  ? darkGreen
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(12),

              border: Border.all(
                color: isSelected
                    ? darkGreen
                    : borderColor,
              ),
            ),

            alignment: Alignment.center,

            child: Text(
              crop,

              style: TextStyle(
                fontSize: 8,

                fontWeight:
                    FontWeight.w600,

                color: isSelected
                    ? Colors.white
                    : const Color(
                        0xFF626A73,
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}