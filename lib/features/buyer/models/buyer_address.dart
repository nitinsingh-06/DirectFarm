class BuyerAddress {
  final int id;
  final String fullName;
  final String phone;
  final String addressLine;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String label;
  final bool isDefault;

  BuyerAddress({
    required this.id,
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

  factory BuyerAddress.fromJson(
    Map<String, dynamic> json,
  ) {
    return BuyerAddress(
      id: int.tryParse(
            (json['address_id'] ??
                    json['id'] ??
                    0)
                .toString(),
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
}