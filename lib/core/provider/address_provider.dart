import 'package:farmdirect/features/buyer/models/buyer_address.dart';
import 'package:flutter/foundation.dart';
import 'package:farmdirect/services/api_services.dart';

class AddressProvider extends ChangeNotifier {
  List<BuyerAddress> _addresses = [];

  bool _isLoading = false;
  String? _error;

  int? _selectedAddressId;

  // ============================================================
  // GETTERS
  // ============================================================

  List<BuyerAddress> get addresses =>
      List.unmodifiable(_addresses);

  bool get isLoading => _isLoading;

  String? get error => _error;

  BuyerAddress? get selectedAddress {
    if (_addresses.isEmpty) {
      return null;
    }

    if (_selectedAddressId != null) {
      for (final address in _addresses) {
        if (address.id == _selectedAddressId) {
          return address;
        }
      }
    }

    // If nothing is explicitly selected,
    // use PostgreSQL default address.
    for (final address in _addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    // Final fallback
    return _addresses.first;
  }

  // ============================================================
  // LOAD BUYER ADDRESSES
  // ============================================================
// ============================================================
// LOAD BUYER ADDRESSES
// ============================================================

Future<void> loadAddresses() async {
  try {
    _isLoading = true;
    _error = null;

    notifyListeners();

    final response =
        await ApiService.getMyAddresses();

    _addresses = response
        .map(
          (item) => BuyerAddress.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    // Select default address
    if (_addresses.isNotEmpty) {
      BuyerAddress? defaultAddress;

      for (final address in _addresses) {
        if (address.isDefault) {
          defaultAddress = address;
          break;
        }
      }

      _selectedAddressId =
          defaultAddress?.id ??
          _addresses.first.id;
    } else {
      _selectedAddressId = null;
    }
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // ============================================================
  // SELECT ADDRESS
  // ============================================================

  void selectAddress(int addressId) {
    final exists = _addresses.any(
      (address) => address.id == addressId,
    );

    if (!exists) {
      return;
    }

    _selectedAddressId = addressId;

    notifyListeners();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await loadAddresses();
  }

  // ============================================================
  // ADD ADDRESS
  // ============================================================

  Future<bool> addAddress({
    required String fullName,
    required String phone,
    required String addressLine,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String label,
    required bool isDefault,
  }) async {
    try {
      _isLoading = true;
      _error = null;

      notifyListeners();

      await ApiService.createAddress(
        fullName: fullName,
        phone: phone,
        addressLine: addressLine,
        landmark: landmark,
        city: city,
        state: state,
        pincode: pincode,
        label: label,
        isDefault: isDefault,
      );

      // Reload from PostgreSQL
      await loadAddresses();

      return true;
    } catch (e) {
      _error = e.toString();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE ADDRESS
  // ============================================================

  Future<bool> updateAddress({
    required int addressId,
    required String fullName,
    required String phone,
    required String addressLine,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String label,
    required bool isDefault,
  }) async {
    try {
      _isLoading = true;
      _error = null;

      notifyListeners();

      await ApiService.updateAddress(
        addressId: addressId,
        fullName: fullName,
        phone: phone,
        addressLine: addressLine,
        landmark: landmark,
        city: city,
        state: state,
        pincode: pincode,
        label: label,
        isDefault: isDefault,
      );

      // Reload updated data
      await loadAddresses();

      return true;
    } catch (e) {
      _error = e.toString();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // DELETE ADDRESS
  // ============================================================

  Future<bool> deleteAddress(
    int addressId,
  ) async {
    try {
      _isLoading = true;
      _error = null;

      notifyListeners();

      await ApiService.deleteAddress(
        addressId: addressId,
      );

      // If deleted address was selected
      if (_selectedAddressId ==
          addressId) {
        _selectedAddressId = null;
      }

      // Reload from PostgreSQL
      await loadAddresses();

      return true;
    } catch (e) {
      _error = e.toString();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // CLEAR PROVIDER
  // ============================================================

  void clearAddresses() {
    _addresses = [];
    _selectedAddressId = null;
    _error = null;

    notifyListeners();
  }
}