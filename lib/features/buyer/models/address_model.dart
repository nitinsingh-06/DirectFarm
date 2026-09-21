class AddressModel {
  final int addressId;
  final int userId;

  final String fullName;
  final String phone;
  final String addressLine;
  final String landmark;
  final String city;
  final String state;
  final String pincode;

  final String label;
  final bool isDefault;

  AddressModel({
    required this.addressId,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.label,
    required this.isDefault,
  });

  factory AddressModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AddressModel(
      addressId:
          int.tryParse(
                json['address_id'].toString(),
              ) ??
              0,

      userId:
          int.tryParse(
                json['user_id'].toString(),
              ) ??
              0,

      fullName:
          json['full_name']?.toString() ??
              '',

      phone:
          json['phone']?.toString() ??
              '',

      addressLine:
          json['address_line']?.toString() ??
              '',

      landmark:
          json['landmark']?.toString() ??
              '',

      city:
          json['city']?.toString() ??
              '',

      state:
          json['state']?.toString() ??
              '',

      pincode:
          json['pincode']?.toString() ??
              '',

      label:
          json['label']?.toString() ??
              'Home',

      isDefault:
          json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'address_line': addressLine,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'label': label,
      'is_default': isDefault,
    };
  }

  String get completeAddress {
    return '$addressLine, $city, $state - $pincode';
  }
}