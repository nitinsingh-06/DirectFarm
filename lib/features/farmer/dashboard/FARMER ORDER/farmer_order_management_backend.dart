  import 'dart:convert';

import 'package:farmdirect/config/api_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


  class FarmerOrder {
    final String id;
    final String orderItemId;
    final String date;
    final String time;
    final String buyerName;
    final String phone;
    final String address;
    final String productName;
    final String productDescription;
    final String quantity;
    final double price;
    final double deliveryCharge;
    String status;

    FarmerOrder({
      required this.id,
      required this.orderItemId,
      required this.date,
      required this.time,
      required this.buyerName,
      required this.phone,
      required this.address,
      required this.productName,
      required this.productDescription,
      required this.quantity,
      required this.price,
      required this.deliveryCharge,
      required this.status,
    });

    double get total => price + deliveryCharge;

    factory FarmerOrder.fromJson(Map<String, dynamic> json) {
      DateTime? createdAt;

      final created = json['created_at'];
      if (created != null) {
        createdAt = DateTime.tryParse(created.toString());
      }

      final rawStatus = json['status']?.toString().toLowerCase() ?? 'pending';

      String status;
      switch (rawStatus) {
        case 'confirmed':
          status = 'Confirmed';
          break;
        case 'shipped':
          status = 'Shipped';
          break;
        case 'delivered':
          status = 'Delivered';
          break;
        case 'rejected':
          status = 'Rejected';
          break;
        case 'cancelled':
          status = 'Cancelled';
          break;
        default:
          status = 'Pending';
      }

      final quantityValue = json['quantity']?.toString() ?? '0';
      final unit = json['unit']?.toString() ?? '';

      final price = _toDouble(json['total_price']);
      final delivery = _toDouble(json['delivery_fee']);

      return FarmerOrder(
        id: json['order_number']?.toString() ??
            '#FD${json['order_id']?.toString() ?? ''}',
        orderItemId: json['order_item_id']?.toString() ?? '',
        date: createdAt == null
            ? ''
            : '${createdAt.day.toString().padLeft(2, '0')} '
              '${_monthName(createdAt.month)}, ${createdAt.year}',
        time: createdAt == null
            ? ''
            : '${((createdAt.hour - 1) % 12) + 1}:'
              '${createdAt.minute.toString().padLeft(2, '0')} '
              '${createdAt.hour >= 12 ? 'PM' : 'AM'}',
        buyerName: json['buyer_name']?.toString() ?? 'Unknown Buyer',
        phone: json['buyer_phone']?.toString() ?? 'Phone unavailable',
        address: json['address']?.toString() ??
            json['location']?.toString() ??
            'Address unavailable',
        productName: json['product_name']?.toString() ?? 'Product',
        productDescription: unit.isEmpty
            ? 'Farm Fresh'
            : 'Farm Fresh • ${unit.toUpperCase()}',
        quantity: '$quantityValue${unit.isEmpty ? '' : ' $unit'}',
        price: price,
        deliveryCharge: delivery,
        status: status,
      );
    }

    static double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    static String _monthName(int month) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return months[month - 1];
    }
  }

  class FarmerOrderManagementScreen extends StatefulWidget {
    const FarmerOrderManagementScreen({super.key});

    @override
    State<FarmerOrderManagementScreen> createState() =>
        _FarmerOrderManagementScreenState();
  }

  class _FarmerOrderManagementScreenState
      extends State<FarmerOrderManagementScreen> {
    int selectedTab = 0;

    final List<FarmerOrder> orders = [];
    bool isLoading = true;
    String? errorMessage;

    @override
    void initState() {
      super.initState();
      _loadFarmerOrders();
    }

    Future<void> _loadFarmerOrders() async {
      if (!mounted) return;

      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          throw Exception('Farmer is not logged in.');
        }

        final idToken = await user.getIdToken(true);

        if (idToken == null || idToken.isEmpty) {
          throw Exception('Unable to get Firebase ID token.');
        }

        final uri = Uri.parse(
          '${ApiConfig.baseUrl}/orders/farmer/my-orders',
        ).replace(
          queryParameters: {
            'id_token': idToken,
          },
        );

        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
          },
        );

        debugPrint(
          'FARMER ORDERS STATUS: ${response.statusCode}',
        );
        debugPrint(
          'FARMER ORDERS RESPONSE: ${response.body}',
        );

        if (response.statusCode != 200) {
          String message = 'Failed to load farmer orders.';

          try {
            final errorBody = jsonDecode(response.body);
            if (errorBody is Map &&
                errorBody['detail'] != null) {
              message = errorBody['detail'].toString();
            }
          } catch (_) {}

          throw Exception(message);
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! Map ||
            decoded['orders'] is! List) {
          throw Exception('Invalid farmer orders response.');
        }

        final loadedOrders = (decoded['orders'] as List)
            .whereType<Map>()
            .map(
              (item) => FarmerOrder.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        if (!mounted) return;

        setState(() {
          orders
            ..clear()
            ..addAll(loadedOrders);
          isLoading = false;
          errorMessage = null;
        });
      } catch (e) {
        debugPrint('FARMER ORDER ERROR: $e');

        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = e.toString().replaceFirst(
                'Exception: ',
                '',
              );
        });
      }
    }

    List<FarmerOrder> get filteredOrders {
      switch (selectedTab) {
        case 0:
          return orders.where((o) => o.status == 'Pending').toList();
        case 1:
          return orders.where((o) => o.status == 'Confirmed').toList();
        case 2:
          return orders.where((o) => o.status == 'Shipped').toList();
        case 3:
          return orders.where((o) => o.status == 'Delivered').toList();
        default:
          return orders;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF8FC),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabs(),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF096B57),
                        ),
                      )
                    : errorMessage != null
                        ? _buildErrorState()
                        : filteredOrders.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                color: const Color(0xFF096B57),
                                onRefresh: _loadFarmerOrders,
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    12,
                                    12,
                                    90,
                                  ),
                                  itemCount: filteredOrders.length,
                                  itemBuilder: (context, index) {
                                    return _buildOrderCard(
                                      filteredOrders[index],
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // HEADER
    // ------------------------------------------------------------
    Widget _buildHeader() {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 14, 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF096B57),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage and track your orders',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            _headerIcon(Icons.search_rounded, () {}),

            const SizedBox(width: 8),

            _headerIcon(Icons.tune_rounded, () {}),
          ],
        ),
      );
    }

    Widget _headerIcon(IconData icon, VoidCallback onTap) {
      return Material(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            width: 45,
            height: 45,
            child: Icon(icon, color: const Color(0xFF17202A), size: 23),
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // TABS
    // ------------------------------------------------------------
    Widget _buildTabs() {
      final tabs = [
        'Pending (${orders.where((o) => o.status == 'Pending').length})',
        'Confirmed (${orders.where((o) => o.status == 'Confirmed').length})',
        'Shipped (${orders.where((o) => o.status == 'Shipped').length})',
        'Delivered (${orders.where((o) => o.status == 'Delivered').length})',
      ];

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final selected = selectedTab == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF096B57)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF75808A),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // ORDER CARD
    // ------------------------------------------------------------
    Widget _buildOrderCard(FarmerOrder order) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E8EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              // TOP
              Row(
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF096B57),
                    ),
                  ),

                  const Spacer(),

                  _statusBadge(order.status),
                ],
              ),

              const SizedBox(height: 3),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${order.date} • ${order.time}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),

              const SizedBox(height: 12),

              // PRODUCT
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productImage(order.productName),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                order.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF18232D),
                                ),
                              ),
                            ),

                            const SizedBox(width: 5),

                            Text(
                              '₹${_formatAmount(order.price)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF08745E),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 3),

                        Text(
                          order.quantity,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 15,
                              color: Color(0xFF68737D),
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                order.buyerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Color(0xFF68737D),
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                order.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // BUTTONS
              Row(
                children: [
                  if (order.status == 'Pending') ...[
                    Expanded(
                      child: _actionButton(
                        label: 'Reject',
                        icon: Icons.close_rounded,
                        background: const Color(0xFFFFE1E1),
                        foreground: const Color(0xFFE13B3B),
                        onTap: () => _rejectOrder(order),
                      ),
                    ),

                    const SizedBox(width: 9),
                  ],

                  Expanded(
                    child: _actionButton(
                      label: 'View Details',
                      icon: Icons.arrow_forward_rounded,
                      background: const Color(0xFF096B57),
                      foreground: Colors.white,
                      onTap: () => _openOrderDetails(order),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // STATUS BADGE
    // ------------------------------------------------------------
    Widget _statusBadge(String status) {
      Color background;
      Color foreground;
      IconData icon;

      switch (status) {
        case 'Confirmed':
          background = const Color(0xFFDDF7E9);
          foreground = const Color(0xFF08745E);
          icon = Icons.check_circle_rounded;
          break;

        case 'Shipped':
          background = const Color(0xFFE4F0FF);
          foreground = const Color(0xFF2866B2);
          icon = Icons.local_shipping_rounded;
          break;

        default:
          background = const Color(0xFFFFF0C9);
          foreground = const Color(0xFFC58A00);
          icon = Icons.access_time_rounded;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: foreground),

            const SizedBox(width: 4),

            Text(
              status == 'Pending' ? 'Pending Accept' : status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
          ],
        ),
      );
    }

    // ------------------------------------------------------------
    // PRODUCT IMAGE
    // ------------------------------------------------------------
    Widget _productImage(String productName) {
      IconData icon = Icons.agriculture_rounded;

      if (productName.toLowerCase().contains('rice')) {
        icon = Icons.grain_rounded;
      } else if (productName.toLowerCase().contains('ghee')) {
        icon = Icons.local_drink_rounded;
      } else if (productName.toLowerCase().contains('tomato')) {
        icon = Icons.spa_rounded;
      } else if (productName.toLowerCase().contains('wheat')) {
        icon = Icons.grass_rounded;
      }

      return Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFFF4EFE5),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, size: 34, color: const Color(0xFF9B7740)),
      );
    }

    // ------------------------------------------------------------
    // ACTION BUTTON
    // ------------------------------------------------------------
    Widget _actionButton({
      required String label,
      required IconData icon,
      required Color background,
      required Color foreground,
      required VoidCallback onTap,
    }) {
      return SizedBox(
        height: 38,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: background,
            foregroundColor: foreground,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // ORDER DETAILS
    // ------------------------------------------------------------

    void _openOrderDetails(FarmerOrder order) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FarmerOrderDetailsScreen(
            order: order,
            onStatusChanged: () {
              _loadFarmerOrders();
            },
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // REJECT
    // ------------------------------------------------------------

    void _rejectOrder(FarmerOrder order) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Reject Order?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: Text('Are you sure you want to reject ${order.id}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    order.status = 'Rejected';
                  });

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE13B3B),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reject'),
              ),
            ],
          );
        },
      );
    }

    // ------------------------------------------------------------
    // EMPTY
    // ------------------------------------------------------------

    Widget _buildErrorState() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: Color(0xFFE13B3B),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Unable to load orders',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF18232D),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadFarmerOrders,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF096B57),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildEmptyState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 55,
                color: Color(0xFF096B57),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No orders found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF18232D),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Orders will appear here when buyers place them.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    String _formatAmount(double amount) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]},',
          );
    }
  }

  // ============================================================================
  // ORDER DETAILS SCREEN
  // ============================================================================

  class FarmerOrderDetailsScreen extends StatefulWidget {
    final FarmerOrder order;
    final VoidCallback onStatusChanged;

    const FarmerOrderDetailsScreen({
      super.key,
      required this.order,
      required this.onStatusChanged,
    });

    @override
    State<FarmerOrderDetailsScreen> createState() =>
        _FarmerOrderDetailsScreenState();
  }

  class _FarmerOrderDetailsScreenState extends State<FarmerOrderDetailsScreen> {
    FarmerOrder get order => widget.order;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF17202A)),
          ),
          title: const Text(
            'Order Details',
            style: TextStyle(
              color: Color(0xFF17202A),
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF17202A)),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: [
                  _buildStatusHeader(),
                  const SizedBox(height: 14),
                  _buildOrderIdCard(),
                  const SizedBox(height: 14),
                  _buildBuyerCard(),
                  const SizedBox(height: 14),
                  _buildProductCard(),
                  const SizedBox(height: 14),
                  _buildPriceCard(),
                  const SizedBox(height: 14),
                  _buildDeliveryCard(),
                ],
              ),
            ),

            if (order.status == 'Pending') _buildPendingActions(),

            if (order.status == 'Confirmed') _buildConfirmedActions(),

            if (order.status == 'Shipped') _buildShippedActions(),
          ],
        ),
      );
    }

    // --------------------------------------------------------------------------
    // STATUS HEADER
    // --------------------------------------------------------------------------

    Widget _buildStatusHeader() {
      final bool pending = order.status == 'Pending';
      final bool confirmed = order.status == 'Confirmed';

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: pending ? const Color(0xFFFFF8E5) : const Color(0xFFEAF8F2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: pending
                        ? const Color(0xFFFFE7A7)
                        : const Color(0xFFD0F0DF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    pending ? Icons.access_time_rounded : Icons.check_rounded,
                    color: pending
                        ? const Color(0xFFD18A00)
                        : const Color(0xFF08745E),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pending
                            ? 'Pending for your action'
                            : confirmed
                            ? 'Order Accepted'
                            : 'Order Shipped',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: pending
                              ? const Color(0xFFC07800)
                              : const Color(0xFF08745E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pending
                            ? 'Please review and accept or reject this order.'
                            : confirmed
                            ? 'Prepare the order and ship it to the buyer.'
                            : 'Order is on the way to the buyer.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildProgress(),
          ],
        ),
      );
    }

    Widget _buildProgress() {
      final current = switch (order.status) {
        'Pending' => 0,
        'Confirmed' => 1,
        'Shipped' => 2,
        'Delivered' => 3,
        _ => 0,
      };

      final labels = ['Pending', 'Confirmed', 'Shipped', 'Delivered'];

      return Row(
        children: List.generate(labels.length, (index) {
          final active = index <= current;

          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF0A9B77) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active
                              ? const Color(0xFF0A9B77)
                              : const Color(0xFFABB4BE),
                          width: 2,
                        ),
                      ),
                      child: active
                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                          : null,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                        color: active
                            ? const Color(0xFF17202A)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                if (index != labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(
                        bottom: 22,
                        left: 4,
                        right: 4,
                      ),
                      color: index < current
                          ? const Color(0xFF0A9B77)
                          : const Color(0xFFD2D7DC),
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    }

    // --------------------------------------------------------------------------
    // ORDER ID
    // --------------------------------------------------------------------------

    Widget _buildOrderIdCard() {
      return _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Order ID',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7D8994)),
                ),
                const Spacer(),
                _smallStatusBadge(),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              order.id,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17202A),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Placed on ${order.date} • ${order.time}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------------------------
    // BUYER
    // --------------------------------------------------------------------------

    Widget _buildBuyerCard() {
      return _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(Icons.person_rounded, 'Buyer Information'),

            const SizedBox(height: 14),

            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3EFF8),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    order.buyerName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF28719E),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.buyerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.phone_rounded,
                            size: 14,
                            color: Color(0xFF6D7883),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            order.phone,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFF6D7883),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              order.address,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.phone_rounded,
                      size: 19,
                      color: Color(0xFF08745E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------------------------
    // PRODUCT
    // --------------------------------------------------------------------------

    Widget _buildProductCard() {
      return _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(Icons.inventory_2_rounded, 'Product Details'),

            const SizedBox(height: 14),

            Row(
              children: [
                _productImage(order.productName),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.productDescription,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${_formatAmount(order.price)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08745E),
                      ),
                    ),
                    Text(
                      '(${order.quantity})',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _infoItem('Quantity', order.quantity),
                  _verticalDivider(),
                  _infoItem(
                    'Price / kg',
                    '₹${(order.price / _quantityNumber(order.quantity)).toStringAsFixed(0)}',
                  ),
                  _verticalDivider(),
                  _infoItem('Subtotal', '₹${_formatAmount(order.price)}'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    double _quantityNumber(String quantity) {
      final value = double.tryParse(quantity.replaceAll(RegExp(r'[^0-9.]'), ''));

      return value == null || value == 0 ? 1 : value;
    }

    Widget _infoItem(String title, String value) {
      return Expanded(
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08745E),
              ),
            ),
          ],
        ),
      );
    }

    Widget _verticalDivider() {
      return Container(width: 1, height: 28, color: const Color(0xFFD4E7DE));
    }

    // --------------------------------------------------------------------------
    // PRICE
    // --------------------------------------------------------------------------

    Widget _buildPriceCard() {
      return _whiteCard(
        child: Column(
          children: [
            _sectionTitle(Icons.currency_rupee_rounded, 'Price Breakdown'),

            const SizedBox(height: 14),

            _priceRow('Product Amount', '₹${_formatAmount(order.price)}'),

            const SizedBox(height: 8),

            _priceRow(
              'Logistics & Delivery',
              '₹${_formatAmount(order.deliveryCharge)}',
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Payout Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF08745E),
                    ),
                  ),
                ),
                Text(
                  '₹${_formatAmount(order.total)}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF08745E),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF0A9B77),
                  size: 21,
                ),
                const SizedBox(width: 9),
                Text(
                  'Payment Verified • Held in Escrow',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _priceRow(String title, String price) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      );
    }

    // --------------------------------------------------------------------------
    // DELIVERY
    // --------------------------------------------------------------------------

    Widget _buildDeliveryCard() {
      return _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(Icons.location_on_rounded, 'Delivery Address'),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.buyerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        order.address,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.map_rounded, size: 16, color: Color(0xFF08745E)),
                      SizedBox(width: 5),
                      Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08745E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------------------------
    // PENDING ACTIONS
    // --------------------------------------------------------------------------

    Widget _buildPendingActions() {
      return _bottomActions(
        leftText: 'Reject Order',
        leftIcon: Icons.close_rounded,
        leftColor: const Color(0xFFFFDCDC),
        leftTextColor: const Color(0xFFD93C3C),
        rightText: 'Accept Order',
        rightIcon: Icons.check_rounded,
        rightColor: const Color(0xFF096B57),
        rightTextColor: Colors.white,
        leftTap: _reject,
        rightTap: _accept,
      );
    }

    // --------------------------------------------------------------------------
    // CONFIRMED ACTIONS
    // --------------------------------------------------------------------------

    Widget _buildConfirmedActions() {
      return _bottomActions(
        leftText: 'Cancel Order',
        leftIcon: Icons.close_rounded,
        leftColor: const Color(0xFFFFE2E2),
        leftTextColor: const Color(0xFFD93C3C),
        rightText: 'Mark as Shipped',
        rightIcon: Icons.local_shipping_rounded,
        rightColor: const Color(0xFF096B57),
        rightTextColor: Colors.white,
        leftTap: _cancelOrder,
        rightTap: _markShipped,
      );
    }

    // --------------------------------------------------------------------------
    // SHIPPED ACTIONS
    // --------------------------------------------------------------------------

    Widget _buildShippedActions() {
      return _bottomActions(
        leftText: 'Contact Buyer',
        leftIcon: Icons.phone_rounded,
        leftColor: const Color(0xFFE6F4EF),
        leftTextColor: const Color(0xFF08745E),
        rightText: 'View Tracking',
        rightIcon: Icons.location_on_rounded,
        rightColor: const Color(0xFF096B57),
        rightTextColor: Colors.white,
        leftTap: () {},
        rightTap: () {},
      );
    }

    Widget _bottomActions({
      required String leftText,
      required IconData leftIcon,
      required Color leftColor,
      required Color leftTextColor,
      required String rightText,
      required IconData rightIcon,
      required Color rightColor,
      required Color rightTextColor,
      required VoidCallback leftTap,
      required VoidCallback rightTap,
    }) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _actionButton(
                text: leftText,
                icon: leftIcon,
                background: leftColor,
                foreground: leftTextColor,
                onTap: leftTap,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _actionButton(
                text: rightText,
                icon: rightIcon,
                background: rightColor,
                foreground: rightTextColor,
                onTap: rightTap,
              ),
            ),
          ],
        ),
      );
    }

    Widget _actionButton({
      required String text,
      required IconData icon,
      required Color background,
      required Color foreground,
      required VoidCallback onTap,
    }) {
      return SizedBox(
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 20),
          label: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: background,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      );
    }

    // --------------------------------------------------------------------------
    // ACCEPT
    // --------------------------------------------------------------------------

    void _accept() {
      setState(() {
        order.status = 'Confirmed';
      });

      widget.onStatusChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order accepted successfully'),
          backgroundColor: Color(0xFF08745E),
        ),
      );
    }

    // --------------------------------------------------------------------------
    // REJECT
    // --------------------------------------------------------------------------

    void _reject() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Reject Order?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: const Text(
              'This order will be rejected and the buyer will be notified.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  order.status = 'Rejected';

                  widget.onStatusChanged();

                  Navigator.pop(context);
                  Navigator.pop(this.context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE13B3B),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reject Order'),
              ),
            ],
          );
        },
      );
    }

    // --------------------------------------------------------------------------
    // CANCEL
    // --------------------------------------------------------------------------

    void _cancelOrder() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Cancel Order?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: const Text('Are you sure you want to cancel this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Order'),
              ),
              ElevatedButton(
                onPressed: () {
                  order.status = 'Cancelled';
                  widget.onStatusChanged();

                  Navigator.pop(context);
                  Navigator.pop(this.context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE13B3B),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel Order'),
              ),
            ],
          );
        },
      );
    }

    // --------------------------------------------------------------------------
    // SHIP
    // --------------------------------------------------------------------------

    void _markShipped() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Mark as Shipped?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: const Text(
              'Confirm that this order has been handed over for delivery.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    order.status = 'Shipped';
                  });

                  widget.onStatusChanged();

                  Navigator.pop(context);

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Order marked as shipped'),
                      backgroundColor: Color(0xFF08745E),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF096B57),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    // --------------------------------------------------------------------------
    // COMMON WIDGETS
    // --------------------------------------------------------------------------

    Widget _whiteCard({required Widget child}) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E8EB)),
        ),
        child: child,
      );
    }

    Widget _sectionTitle(IconData icon, String title) {
      return Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF17202A)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17202A),
            ),
          ),
        ],
      );
    }

    Widget _smallStatusBadge() {
      final pending = order.status == 'Pending';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: pending ? const Color(0xFFFFF0C9) : const Color(0xFFDDF7E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          pending ? 'Pending Accept' : order.status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: pending ? const Color(0xFFC58A00) : const Color(0xFF08745E),
          ),
        ),
      );
    }

    Widget _productImage(String productName) {
      IconData icon = Icons.agriculture_rounded;

      if (productName.toLowerCase().contains('rice')) {
        icon = Icons.grain_rounded;
      } else if (productName.toLowerCase().contains('ghee')) {
        icon = Icons.local_drink_rounded;
      } else if (productName.toLowerCase().contains('tomato')) {
        icon = Icons.spa_rounded;
      } else if (productName.toLowerCase().contains('wheat')) {
        icon = Icons.grass_rounded;
      }

      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFF4EFE5),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, size: 38, color: const Color(0xFF9B7740)),
      );
    }

    String _formatAmount(double amount) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]},',
          );
    }
  }
