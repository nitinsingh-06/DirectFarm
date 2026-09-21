import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/address/add_adresses_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/address/edit_address_screen.dart';
import 'package:farmdirect/features/buyer/models/address_model.dart';
import 'package:flutter/material.dart';

import 'package:farmdirect/services/api_services.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  static const primary = Color(0xFF075B4A);

  static const lightGreen = Color(0xFFEAF7F1);

  static const background = Color(0xFFF7FAF9);

  static const textDark = Color(0xFF20332E);

  static const textGrey = Color(0xFF788580);

  static const red = Color(0xFFFF4D4D);

  List<AddressModel> addresses = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _loadAddresses();
  }
Future<void> _loadAddresses() async {
  try {
    setState(() {
      loading = true;
    });

    final response =
        await ApiService.getMyAddresses();

    final loadedAddresses = response
        .map(
          (item) => AddressModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    if (!mounted) return;

    setState(() {
      addresses = loadedAddresses;
      loading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      loading = false;
    });

    debugPrint(
      'LOAD ADDRESS ERROR: $e',
    );

    _message(
      'Unable to load addresses',
    );
  }
}
  // ============================================================
  // ADD
  // ============================================================
Future<void> _addAddress() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AddAddressScreen(),
    ),
  );

  if (result == true) {
    await _loadAddresses();
  }
}

  // ============================================================
  // EDIT
  // ============================================================
Future<void> _editAddress(
  AddressModel address,
) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditAddressScreen(
        address: address,
      ),
    ),
  );

  if (result == true) {
    await _loadAddresses();
  }
}

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _deleteAddress(AddressModel address) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Address?'),
          content: const Text('This address will be permanently removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await ApiService.deleteAddress(addressId: address.addressId);

      await _loadAddresses();

      _message('Address deleted');
    } catch (e) {
      _message('Failed to delete address');
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: primary),
        ),

        title: const Text(
          'Saved Addresses',
          style: TextStyle(
            color: primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : addresses.isEmpty
          ? _emptyState()
          : RefreshIndicator(
              color: primary,
              onRefresh: _loadAddresses,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 90),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return _addressCard(addresses[index]);
                },
              ),
            ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: SizedBox(
            height: 47,
            child: ElevatedButton(
              onPressed: _addAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                '+  Add New Address',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _addressCard(AddressModel address) {
    final isDefault = address.isDefault;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDefault ? primary : const Color(0xFFE1E6E3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  address.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    color: primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const Spacer(),

              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            address.fullName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            address.completeAddress,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, height: 1.3, color: textGrey),
          ),

          if (address.landmark.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              'Landmark: ${address.landmark}',
              style: const TextStyle(fontSize: 8, color: textGrey),
            ),
          ],

          const SizedBox(height: 7),

          Row(
            children: [
              const Icon(Icons.phone, size: 10, color: textGrey),
              const SizedBox(width: 4),
              Text(
                address.phone,
                style: const TextStyle(fontSize: 9, color: textGrey),
              ),

              const Spacer(),

              TextButton.icon(
                onPressed: () => _editAddress(address),
                icon: const Icon(Icons.edit_outlined, size: 13),
                label: const Text('Edit', style: TextStyle(fontSize: 9)),
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(width: 5),

              TextButton.icon(
                onPressed: () => _deleteAddress(address),
                icon: const Icon(Icons.delete_outline, size: 13),
                label: const Text('Delete', style: TextStyle(fontSize: 9)),
                style: TextButton.styleFrom(
                  foregroundColor: red,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        'No saved addresses',
        style: TextStyle(color: textGrey, fontSize: 15),
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
