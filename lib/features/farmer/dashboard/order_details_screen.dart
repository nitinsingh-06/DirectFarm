import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String buyerName;
  final String buyerAddress;
  final String productName;
  final String quantity;
  final String price;
  final String logistics;
  final String totalAmount;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.buyerName,
    required this.buyerAddress,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.logistics,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                14,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE8ECEF),
                  ),
                ),
              ),
              child: const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF075B47),
                ),
              ),
            ),

            // =====================================================
            // CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // ORDER INFORMATION
                    // =================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: #$orderId',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF075B47),
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              'Placed on 15 Oct, 2026',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF8A939B),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0C2),
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC48A00),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _buildDivider(),

                    const SizedBox(height: 14),

                    // =================================================
                    // BUYER INFORMATION
                    // =================================================

                    const Text(
                      'BUYER INFORMATION',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C858C),
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      buyerName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF27313A),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      buyerAddress,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF7D858D),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildDivider(),

                    const SizedBox(height: 14),

                    // =================================================
                    // ITEMS SUMMARY
                    // =================================================

                    const Text(
                      'ITEMS SUMMARY',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C858C),
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$productName ($quantity)',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF39434B),
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'Logistics & Delivery',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFF8A939B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF27313A),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              logistics,
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF8A939B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _buildDivider(),

                    const SizedBox(height: 12),

                    // =================================================
                    // TOTAL PAYOUT
                    // =================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payout Amount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF075B47),
                          ),
                        ),

                        Text(
                          totalAmount,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF075B47),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // =================================================
                    // PAYMENT VERIFIED
                    // =================================================

                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 14,
                          color: Color(0xFF0A9B76),
                        ),

                        const SizedBox(width: 7),

                        const Text(
                          'Payment Verified (Held in Escrow)',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF4F5B63),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // BUTTONS
                    // =================================================

                    Row(
                      children: [
                        // ------------------------------------------------
                        // REJECT
                        // ------------------------------------------------

                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  'rejected',
                                );
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color(0xFFFFE1E1),
                                foregroundColor:
                                    const Color(0xFFE55353),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ------------------------------------------------
                        // ACCEPT
                        // ------------------------------------------------

                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  'accepted',
                                );
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color(0xFF075B47),
                                foregroundColor:
                                    Colors.white,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // DIVIDER
  // ===============================================================

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFE9EDF0),
    );
  }
}