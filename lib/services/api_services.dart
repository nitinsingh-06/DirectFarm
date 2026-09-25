import 'dart:convert';
import 'package:farmdirect/config/api_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ============================================================
  // CREATE USER - REGISTRATION
  // ============================================================

  static Future<Map<String, dynamic>> createUser({
    required String firebaseUid,
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'firebase_uid': firebaseUid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'User creation failed');
    }

    throw Exception('Server error: ${response.statusCode}');
  }

  // ============================================================
  // GET USER BY FIREBASE UID
  // ============================================================

  static Future<Map<String, dynamic>> getUserByFirebaseUid({
    required String firebaseUid,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/by-firebase/$firebaseUid'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 404) {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'User not found');
    }

    throw Exception('Server error: ${response.statusCode}');
  }

  // ===================================
  // UPDATE USER
  // =====================================
  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'phone': phone}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to update user: ${response.body}');
  }

  // ============================================================
  // UPLOAD PROFILE IMAGE
  // ============================================================

  static Future<Map<String, dynamic>> uploadProfileImage({
    required int userId,
    required String imagePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/profile-image'),
    );

    request.headers['Accept'] = 'application/json';

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    debugPrint('UPLOAD STATUS: ${response.statusCode}');
    debugPrint('UPLOAD RESPONSE: ${response.body}');

    throw Exception('Failed to upload profile image: ${response.body}');
  }

  static Future<Map<String, dynamic>> getFarmerProfile({
    required int userId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/farmer-profile/$userId'),
      headers: {'Accept': 'application/json'},
    );

    debugPrint('GET FARMER PROFILE STATUS: ${response.statusCode}');

    debugPrint('GET FARMER PROFILE RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load farmer profile: ${response.body}');
  }

  static Future<Map<String, dynamic>> updateFarmerProfile({
    required int userId,
    required String farmName,
    required String farmType,
    required double? farmSize,
    required List<String> crops,
    required String certifications,
    required int? yearsOfExperience,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/farmer-profile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'farm_name': farmName,
        'farm_type': farmType,
        'farm_size': farmSize,
        'crops': crops,
        'certifications': certifications,
        'years_of_experience': yearsOfExperience,
      }),
    );

    debugPrint('UPDATE FARMER PROFILE STATUS: ${response.statusCode}');

    debugPrint('UPDATE FARMER PROFILE RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to update farmer profile: ${response.body}');
  }

  // ============================================================
  // CREATE PRODUCT
  // FARMER ONLY
  // ============================================================
  static Future<Map<String, dynamic>> createProduct({
    required String idToken,
    required String name,
    String? description,
    required int categoryId,
    required double price,
    required String unit,
    required double quantityAvailable,
    String? imageUrl,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/products',
    ).replace(queryParameters: {'id_token': idToken});

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'category_id': categoryId,
        'price': price,
        'unit': unit,
        'quantity_available': quantityAvailable,
        'image_url': imageUrl,
      }),
    );

    debugPrint('CREATE PRODUCT STATUS: ${response.statusCode}');

    debugPrint('CREATE PRODUCT RESPONSE: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    try {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'Failed to create product');
    } on FormatException {
      throw Exception('Failed to create product: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------------------
  //  GET MY PRODUCT (FARMER)
  // ----------------------------------------------------------------
  static Future<List<dynamic>> getMyProducts({required String idToken}) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/products/my-products',
    ).replace(queryParameters: {'id_token': idToken});

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    debugPrint('GET MY PRODUCTS STATUS: ${response.statusCode}');

    debugPrint('GET MY PRODUCTS RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    try {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'Failed to load products');
    } on FormatException {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // ============================================================
  // GET ALL PRODUCTS
  // BUYER HOME
  // ============================================================

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: {'Accept': 'application/json'},
    );

    debugPrint('GET ALL PRODUCTS STATUS: ${response.statusCode}');

    debugPrint('GET ALL PRODUCTS RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    try {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'Failed to load products');
    } on FormatException {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------
  //  UPLOAD IMAGES OF PRODUCT
  // -------------------------------------------------------
  static Future<String> uploadProductImage({required String imagePath}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/products/upload-image'),
    );

    request.headers['Accept'] = 'application/json';

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('UPLOAD PRODUCT IMAGE STATUS: ${response.statusCode}');

    debugPrint('UPLOAD PRODUCT IMAGE RESPONSE: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      return body['image_url'].toString();
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      throw Exception(body['detail'] ?? 'Image upload failed');
    } on FormatException {
      throw Exception('Image upload failed: ${response.statusCode}');
    }
  }




  
  // -------------------------------------------------------
  //  BUYER ADDRESS
  // -------------------------------------------------------
 static Future<List<dynamic>> getMyAddresses() async {
  final user =
      FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception(
      'User is not logged in',
    );
  }

  final token =
      await user.getIdToken();

  final response = await http.get(
    Uri.parse(
      '${ApiConfig.baseUrl}/addresses/me'
      '?id_token=$token',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load addresses: '
      '${response.body}',
    );
  }

  final decoded =
      jsonDecode(response.body);

  if (decoded is List) {
    return decoded;
  }

  return [];
}



  // -------------------------------------------------------
  //  CREATE ADDRESS OF BUYER
  // -------------------------------------------------------
  static Future<void> createAddress({
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
  final user =
      FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception(
      'User is not logged in',
    );
  }

  final token =
      await user.getIdToken();

  final response = await http.post(
    Uri.parse(
      '${ApiConfig.baseUrl}/addresses'
      '?id_token=$token',
    ),
    headers: {
      'Content-Type':
          'application/json',
    },
    body: jsonEncode({
      'full_name': fullName,
      'phone': phone,
      'address_line': addressLine,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'label': label,
      'is_default': isDefault,
    }),
  );

  if (response.statusCode != 200 &&
      response.statusCode != 201) {
    throw Exception(
      response.body,
    );
  }
}


  // -------------------------------------------------------
  //  UPDATE ADDRESS OF BUYER
  // -------------------------------------------------------
  static Future<void> updateAddress({
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
  final user =
      FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception(
      'User is not logged in',
    );
  }

  final token =
      await user.getIdToken();

  final response = await http.put(
    Uri.parse(
      '${ApiConfig.baseUrl}/addresses/'
      '$addressId'
      '?id_token=$token',
    ),
    headers: {
      'Content-Type':
          'application/json',
    },
    body: jsonEncode({
      'full_name': fullName,
      'phone': phone,
      'address_line': addressLine,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'label': label,
      'is_default': isDefault,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      response.body,
    );
  }
}



  // -------------------------------------------------------
  //  DELETE ADDRESS OF BUYER
  // -------------------------------------------------------


static Future<void> deleteAddress({
  required int addressId,
}) async {
  final user =
      FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception(
      'User is not logged in',
    );
  }

  final token =
      await user.getIdToken();

  final response = await http.delete(
    Uri.parse(
      '${ApiConfig.baseUrl}/addresses/'
      '$addressId'
      '?id_token=$token',
    ),
  );

  if (response.statusCode != 200 &&
      response.statusCode != 204) {
    throw Exception(
      response.body,
    );
  }
}



// ============================================================
// BUYER CART - GET MY CART
// ============================================================

static Future<List<dynamic>> getMyCart() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final response = await http.get(
    Uri.parse(
      '${ApiConfig.baseUrl}/cart/me?id_token=$token',
    ),
    headers: {
      'Accept': 'application/json',
    },
  );

  debugPrint(
    'GET CART STATUS: ${response.statusCode}',
  );

  debugPrint(
    'GET CART RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    }

    return [];
  }

  throw Exception(
    'Failed to load cart: ${response.body}',
  );
}



// ============================================================
// BUYER CART - ADD ITEM
// ============================================================

static Future<Map<String, dynamic>> addCartItem({
  required int productId,
  required int quantity,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final response = await http.post(
    Uri.parse(
      '${ApiConfig.baseUrl}/cart/items?id_token=$token',
    ),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'product_id': productId,
      'quantity': quantity,
    }),
  );

  debugPrint(
    'ADD CART STATUS: ${response.statusCode}',
  );

  debugPrint(
    'ADD CART RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }

  throw Exception(
    'Failed to add item to cart: ${response.body}',
  );
}



// ============================================================
// BUYER CART - UPDATE ITEM
// ============================================================

static Future<Map<String, dynamic>> updateCartItem({
  required int cartItemId,
  required int quantity,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final response = await http.patch(
    Uri.parse(
      '${ApiConfig.baseUrl}/cart/items/$cartItemId?id_token=$token',
    ),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'quantity': quantity,
    }),
  );

  debugPrint(
    'UPDATE CART STATUS: ${response.statusCode}',
  );

  debugPrint(
    'UPDATE CART RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }

  throw Exception(
    'Failed to update cart: ${response.body}',
  );
}

// ============================================================
// BUYER CART - REMOVE ITEM
// ============================================================

static Future<void> removeCartItem({
  required int cartItemId,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final response = await http.delete(
    Uri.parse(
      '${ApiConfig.baseUrl}/cart/items/$cartItemId?id_token=$token',
    ),
    headers: {
      'Accept': 'application/json',
    },
  );

  debugPrint(
    'REMOVE CART STATUS: ${response.statusCode}',
  );

  debugPrint(
    'REMOVE CART RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200 ||
      response.statusCode == 204) {
    return;
  }

  throw Exception(
    'Failed to remove cart item: ${response.body}',
  );
}

// ============================================================
// BUYER CART - CLEAR CART
// ============================================================

static Future<void> clearCart() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final response = await http.delete(
    Uri.parse(
      '${ApiConfig.baseUrl}/cart/me?id_token=$token',
    ),
    headers: {
      'Accept': 'application/json',
    },
  );

  debugPrint(
    'CLEAR CART STATUS: ${response.statusCode}',
  );

  debugPrint(
    'CLEAR CART RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200 ||
      response.statusCode == 204) {
    return;
  }

  throw Exception(
    'Failed to clear cart: ${response.body}',
  );
}




// ============================================================
// BUYER ORDERS - CREATE ORDER
// ============================================================

static Future<Map<String, dynamic>> createOrder({
  required int addressId,
  required String paymentMethod,
  required String deliveryDate,
  required String deliverySlot,
  required String deliveryInstructions,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final uri = Uri.parse(
    '${ApiConfig.baseUrl}/orders/',
  ).replace(
    queryParameters: {
      'address_id': addressId.toString(),
      'payment_method': paymentMethod,
      'delivery_date': deliveryDate,
      'delivery_slot': deliverySlot,
      'delivery_instructions': deliveryInstructions,
      'id_token': token ?? '',
    },
  );

  final response = await http.post(
    uri,
    headers: {
      'Accept': 'application/json',
    },
  );

  debugPrint('CREATE ORDER STATUS: ${response.statusCode}');
  debugPrint('CREATE ORDER RESPONSE: ${response.body}');

  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }

  try {
    final body = jsonDecode(response.body);

    throw Exception(
      body['detail'] ?? 'Failed to place order',
    );
  } catch (e) {
    if (e is Exception) {
      rethrow;
    }

    throw Exception(
      'Failed to place order: ${response.statusCode}',
    );
  }

  
}



// ============================================================
// BUYER ORDERS - GET MY ORDERS
// ============================================================

static Future<List<dynamic>> getMyOrders() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  final token = await user.getIdToken();

  final uri = Uri.parse(
    '${ApiConfig.baseUrl}/orders/me',
  ).replace(
    queryParameters: {
      'id_token': token ?? '',
    },
  );

  final response = await http.get(
    uri,
    headers: {
      'Accept': 'application/json',
    },
  );

  debugPrint(
    'GET MY ORDERS STATUS: ${response.statusCode}',
  );

  debugPrint(
    'GET MY ORDERS RESPONSE: ${response.body}',
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      final orders = decoded['orders'];

      if (orders is List) {
        return orders;
      }
    }

    return [];
  }

  try {
    final body = jsonDecode(response.body);

    throw Exception(
      body['detail'] ?? 'Failed to load orders',
    );
  } catch (e) {
    if (e is Exception) {
      rethrow;
    }

    throw Exception(
      'Failed to load orders: ${response.statusCode}',
    );
  }
}


// ============================================================
// CANCEL MY ORDER
// ============================================================

static Future<Map<String, dynamic>> cancelOrder(
  int orderId,
) async {
  final user =
      FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception(
      'User is not logged in',
    );
  }

  final token =
      await user.getIdToken();

  final uri = Uri.parse(
    '${ApiConfig.baseUrl}/orders/$orderId/cancel',
  ).replace(
    queryParameters: {
      'id_token': token ?? '',
    },
  );

  final response = await http.post(
    uri,

    headers: {
      'Accept':
          'application/json',
    },
  );

  debugPrint(
    'CANCEL ORDER STATUS: '
    '${response.statusCode}',
  );

  debugPrint(
    'CANCEL ORDER RESPONSE: '
    '${response.body}',
  );

  if (response.statusCode == 200) {
    final decoded =
        jsonDecode(response.body);

    if (decoded
        is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception(
      'Invalid cancel order response',
    );
  }

  try {
    final decoded =
        jsonDecode(response.body);

    if (decoded
        is Map<String, dynamic>) {
      throw Exception(
        decoded['detail'] ??
            'Failed to cancel order',
      );
    }
  } catch (e) {
    if (e is Exception) {
      rethrow;
    }
  }

  throw Exception(
    'Failed to cancel order '
    '(${response.statusCode})',
  );
}



static Future<List<dynamic>> getCategories() async {
  final response = await http.get(
    Uri.parse("${ApiConfig.baseUrl}/categories/"),
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }

  throw Exception(
    "Failed to load categories: ${response.statusCode}",
  );
}

}
