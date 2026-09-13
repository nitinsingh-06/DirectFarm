import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarmDetailsScreen extends StatefulWidget {
  const FarmDetailsScreen({super.key});

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  // ============================================================
  // LOADING
  // ============================================================

  bool _isLoading = true;
  bool _isUpdating = false;

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _farmNameController = TextEditingController();

  final TextEditingController _farmSizeController = TextEditingController();

  final TextEditingController _certificationController =
      TextEditingController();

  final TextEditingController _experienceController = TextEditingController();

  // ============================================================
  // FARM TYPE
  // ============================================================

  String _selectedFarmType = 'Organic';

  final List<String> _farmTypes = [
    'Organic',
    'Conventional',
    'Mixed Farming',
    'Natural Farming',
  ];

  // ============================================================
  // PRIMARY CROPS
  // ============================================================

  final List<String> _crops = [
    'Basmati Rice',
    'Golden Wheat',
    'Red Potatoes',
    'Mustard',
    'Alphonso Mango',
  ];

  // Loaded from PostgreSQL
  final Set<String> _selectedCrops = {};

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadFarmDetails();
  }

  // ============================================================
  // LOAD FARM DETAILS FROM DATABASE
  // ============================================================

  Future<void> _loadFarmDetails() async {
    try {
      final profile = context.read<ProfileProvider>();

      final userId = profile.userId;

      if (userId == null) {
        throw Exception('Farmer user ID not found');
      }

      debugPrint('Loading farm details for user ID: $userId');

      final data = await ApiService.getFarmerProfile(userId: userId);

      if (!mounted) return;

      setState(() {
        // ------------------------------------------------------
        // FARM NAME
        // ------------------------------------------------------

        _farmNameController.text = data['farm_name']?.toString() ?? '';

        // ------------------------------------------------------
        // FARM SIZE
        // ------------------------------------------------------

        final farmSize = data['farm_size'];

        _farmSizeController.text = farmSize != null ? farmSize.toString() : '';

        // ------------------------------------------------------
        // FARM TYPE
        // ------------------------------------------------------

        final farmType = data['farm_type']?.toString();

        if (farmType != null && _farmTypes.contains(farmType)) {
          _selectedFarmType = farmType;
        }

        // ------------------------------------------------------
        // CERTIFICATIONS
        // ------------------------------------------------------

        _certificationController.text =
            data['certifications']?.toString() ?? '';

        // ------------------------------------------------------
        // YEARS OF EXPERIENCE
        // ------------------------------------------------------

        final experience = data['years_of_experience'];

        _experienceController.text = experience != null
            ? experience.toString()
            : '';

        // ------------------------------------------------------
        // PRIMARY CROPS
        // ------------------------------------------------------

        _selectedCrops.clear();

        final crops = data['crops'];

        if (crops is List) {
          for (final crop in crops) {
            final cropName = crop.toString();

            if (_crops.contains(cropName)) {
              _selectedCrops.add(cropName);
            }
          }
        }

        _isLoading = false;
      });

      debugPrint('Farm details loaded successfully');
    } catch (e) {
      debugPrint('Farm details loading error: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load farm details: $e')),
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmSizeController.dispose();
    _certificationController.dispose();
    _experienceController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF075B47),
                  size: 19,
                ),
              ),
            ),
          ),
        ),

        title: const Text(
          'Farm Details',
          style: TextStyle(
            color: Color(0xFF075B47),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        titleSpacing: 4,

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE7E7E7)),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF075B47)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 14, 13, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // FARM NAME
                    // ==================================================
                    _buildLabel('Farm Name / FPO Name'),

                    _buildTextField(controller: _farmNameController),

                    const SizedBox(height: 11),

                    // ==================================================
                    // FARM TYPE
                    // ==================================================
                    _buildLabel('Farm Type'),

                    _buildFarmTypeDropdown(),

                    const SizedBox(height: 11),

                    // ==================================================
                    // FARM SIZE
                    // ==================================================
                    _buildLabel('Farm Size (in Acres)'),

                    _buildTextField(
                      controller: _farmSizeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 11),

                    // ==================================================
                    // PRIMARY CROPS
                    // ==================================================
                    _buildLabel('Primary Crops'),

                    _buildCropSelection(),

                    const SizedBox(height: 12),

                    // ==================================================
                    // CERTIFICATIONS
                    // ==================================================
                    _buildLabel('Certifications (e.g. NPOP, PGS)'),

                    _buildTextField(controller: _certificationController),

                    const SizedBox(height: 11),

                    // ==================================================
                    // EXPERIENCE
                    // ==================================================
                    _buildLabel('Years of Experience'),

                    _buildTextField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
      ),

      // ========================================================
      // UPDATE BUTTON
      // ========================================================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 7, 13, 9),
          child: SizedBox(
            height: 33,
            child: ElevatedButton(
              onPressed: _isLoading || _isUpdating ? null : _updateDetails,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075B47),
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: Colors.black26,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: _isUpdating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Update Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF27343A),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        style: const TextStyle(fontSize: 13, color: Color(0xFF39444A)),

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E5E7)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E5E7)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF075B47)),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FARM TYPE DROPDOWN
  // ============================================================

  Widget _buildFarmTypeDropdown() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E5E7)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFarmType,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Color(0xFF7B8790),
          ),

          style: const TextStyle(fontSize: 13, color: Color(0xFF39444A)),

          items: _farmTypes.map((String type) {
            return DropdownMenuItem<String>(value: type, child: Text(type));
          }).toList(),

          onChanged: (String? value) {
            if (value == null) return;

            setState(() {
              _selectedFarmType = value;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // CROP SELECTION
  // ============================================================

  Widget _buildCropSelection() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,

      children: _crops.map((crop) {
        final bool selected = _selectedCrops.contains(crop);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                _selectedCrops.remove(crop);
              } else {
                _selectedCrops.add(crop);
              }
            });
          },

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

            decoration: BoxDecoration(
              color: selected ? const Color(0xFF075B47) : Colors.white,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: selected
                    ? const Color(0xFF075B47)
                    : const Color(0xFFE0E5E7),
              ),
            ),

            child: Text(
              crop,

              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,

                color: selected ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // UPDATE DETAILS
  // ============================================================

  Future<void> _updateDetails() async {
    FocusScope.of(context).unfocus();

    final profile = context.read<ProfileProvider>();

    final userId = profile.userId;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Farmer ID not found')));

      return;
    }

    // ----------------------------------------------------------
    // GET VALUES
    // ----------------------------------------------------------

    final farmName = _farmNameController.text.trim();

    final farmSizeText = _farmSizeController.text.trim();

    final certification = _certificationController.text.trim();

    final experienceText = _experienceController.text.trim();

    // ----------------------------------------------------------
    // VALIDATE FARM NAME
    // ----------------------------------------------------------

    if (farmName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter farm name')));

      return;
    }

    // ----------------------------------------------------------
    // FARM SIZE
    // ----------------------------------------------------------

    double? farmSize;

    if (farmSizeText.isNotEmpty) {
      farmSize = double.tryParse(farmSizeText);

      if (farmSize == null || farmSize < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid farm size')),
        );

        return;
      }
    }

    // ----------------------------------------------------------
    // EXPERIENCE
    // ----------------------------------------------------------

    int? experience;

    if (experienceText.isNotEmpty) {
      experience = int.tryParse(experienceText);

      if (experience == null || experience < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid years of experience'),
          ),
        );

        return;
      }
    }

    // ----------------------------------------------------------
    // START UPDATE
    // ----------------------------------------------------------

    setState(() {
      _isUpdating = true;
    });

    try {
      final updatedProfile = await ApiService.updateFarmerProfile(
        userId: userId,
        farmName: farmName,
        farmType: _selectedFarmType,
        farmSize: farmSize,
        crops: _selectedCrops.toList(),
        certifications: certification,
        yearsOfExperience: experience,
      );

      debugPrint(
        'Updated farmer profile: '
        '$updatedProfile',
      );

      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm details updated successfully')),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pop(context, 'Update Details');
    } catch (e) {
      debugPrint('Farm update error: $e');

      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update farm details: $e')),
      );
    }
  }
}
