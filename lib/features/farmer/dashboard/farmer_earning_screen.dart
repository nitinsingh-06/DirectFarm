import 'package:flutter/material.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int selectedFilter = 0;

  final List<String> filters = [
    'This Week',
    'This Month',
    'This Year',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceSection(),

                  const SizedBox(height: 11),

                  _buildFilters(),

                  const SizedBox(height: 8),

                  _buildChart(),

                  const SizedBox(height: 12),

                  _buildRecentWithdrawals(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: const Text(
        'My Earnings',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF075640),
        ),
      ),
    );
  }

  // ============================================================
  // BALANCE SECTION
  // ============================================================

  Widget _buildBalanceSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F4C3A),
      padding: const EdgeInsets.fromLTRB(
        9,
        13,
        13,
        11,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '₹1,45,600',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                _showWithdrawDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF84D20A),
                foregroundColor: const Color(0xFF0A3326),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Withdraw to Bank',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {
    return SizedBox(
      height: 21,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final bool selected = selectedFilter == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 7),
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF377C6D)
                      : const Color(0xFFE2E7EA),
                  width: selected ? 1 : 0.8,
                ),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 7.5,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? const Color(0xFF075640)
                      : const Color(0xFF8A939D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // EARNINGS CHART
  // ============================================================

  Widget _buildChart() {
    final List<double> heights = [
      26,
      34,
      30,
      53,
      38,
      49,
      53,
      58,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9),
      height: 68,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        7,
        6,
        7,
        7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE3E7EA),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          heights.length,
          (index) {
            final bool selected = index == 3;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: heights[index],
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF83D10A)
                          : const Color(0xFFE8FAF2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // RECENT WITHDRAWALS
  // ============================================================

  Widget _buildRecentWithdrawals() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Withdrawals',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF075640),
            ),
          ),

          const SizedBox(height: 8),

          _withdrawalCard(
            title: 'Transfer to State Bank of India',
            date: '12 Oct, 2026 • Txn: #SBI-09432',
            amount: '- ₹25,000',
            amountColor: const Color(0xFFF04444),
          ),

          const SizedBox(height: 7),

          _withdrawalCard(
            title: 'Escrow Payout #FD1201',
            date: '10 Oct, 2026',
            amount: '+ ₹12,400',
            amountColor: const Color(0xFF0BA579),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WITHDRAWAL CARD
  // ============================================================

  Widget _withdrawalCard({
    required String title,
    required String date,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE3E7EA),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 6.8,
                    color: Color(0xFF7A8491),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            amount,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WITHDRAW DIALOG
  // ============================================================

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'Withdraw to Bank',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF075640),
            ),
          ),
          content: const Text(
            'Your available balance is ₹1,45,600.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075640),
                foregroundColor: Colors.white,
              ),
              child: const Text('Withdraw'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Withdrawal request submitted successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}