import 'package:farmdirect/core/widgets/farmer_crop_selector_widgets.dart';
import 'package:farmdirect/core/widgets/farmer_input_field_widgets.dart';
import 'package:flutter/material.dart';

class FarmerRegisterPage extends StatefulWidget {
  const FarmerRegisterPage({super.key});

  @override
  State<FarmerRegisterPage> createState() => _FarmerRegisterPageState();
}

class _FarmerRegisterPageState extends State<FarmerRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController farmNameController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController aadhaarController =
      TextEditingController();

  // Multiple crop selection
  Set<String> selectedCrops = {'Wheat'};

  final List<String> crops = [
    'Wheat',
    'Rice',
    'Potato',
    'Cotton',
    'Other',
  ];

  // Colors
  static const Color primaryGreen = Color(0xFF7CD000);
  static const Color darkGreen = Color(0xFF155B4B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color borderColor = Color(0xFFE2E5E8);
  static const Color hintColor = Color(0xFF969DA7);

  @override
  void dispose() {
    fullNameController.dispose();
    farmNameController.dispose();
    locationController.dispose();
    aadhaarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==================================================
                  // HEADER
                  // ==================================================

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),

                    child: Row(
                      children: [

                        const Text(
                          'Farmer Register',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: darkGreen,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          'Step 1 of 2',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // SPACE
                  // ==================================================

                  SizedBox(
                    height: size.height * 0.115,
                  ),

                  // ==================================================
                  // FULL NAME
                  // ==================================================

                  const FieldLabel(
                    text: 'Full Name',
                  ),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: fullNameController,
                    hintText: 'e.g. Ramesh Kumar',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // FARM NAME
                  // ==================================================

                  const FieldLabel(
                    text: 'Farm Name / FPO Name',
                  ),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: farmNameController,
                    hintText: 'e.g. Kumar Organic Farms',
                    icon: Icons.home_outlined,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // LOCATION
                  // ==================================================

                  const FieldLabel(
                    text: 'Location (State, District)',
                  ),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: locationController,
                    hintText: 'e.g. Punjab, Ludhiana',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // AADHAAR
                  // ==================================================

                  const FieldLabel(
                    text: 'Aadhaar / Gov ID',
                  ),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: aadhaarController,
                    hintText: '12-digit Aadhaar number',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 11),

                  // ==================================================
                  // MAJOR CROPS
                  // ==================================================

                  const FieldLabel(
                    text: 'Major Crops Grown',
                  ),

                  const SizedBox(height: 5),

                  CropSelector(
                    crops: crops,
                    selectedCrops: selectedCrops,
                    onChanged: (updatedCrops) {
                      setState(() {
                        selectedCrops = updatedCrops;
                      });
                    },
                  ),

                  // ==================================================
                  // REGISTER BUTTON
                  // ==================================================

                  SizedBox(
                    height: size.height * 0.14,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 37,

                    child: ElevatedButton(
                      onPressed: registerFarmer,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.black,

                        elevation: 4,

                        shadowColor:
                            primaryGreen.withOpacity(0.30),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                      ),

                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Text(
                            'Register Farmer',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(width: 5),

                          Icon(
                            Icons.person_add_alt_1,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // REGISTER FARMER
  // ================================================================

  void registerFarmer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    debugPrint(
      'Full Name: ${fullNameController.text}',
    );

    debugPrint(
      'Farm Name: ${farmNameController.text}',
    );

    debugPrint(
      'Location: ${locationController.text}',
    );

    debugPrint(
      'Aadhaar: ${aadhaarController.text}',
    );

    debugPrint(
      'Selected Crops: ${selectedCrops.join(', ')}',
    );

    // Navigate to Step 2 here.

    // Example:
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const FarmerRegisterStep2(),
    //   ),
    // );
  }
}

// ====================================================================
// FIELD LABEL
// ====================================================================

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF28313D),
      ),
    );
  }
}
