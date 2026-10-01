import 'package:farmdirect/features/farmer/earnings/model/earnings_model.dart';
import 'package:farmdirect/features/farmer/earnings/repositories/earnings_mock_interview.dart';
import 'package:farmdirect/features/farmer/earnings/repositories/earnings_repositories.dart';
import 'package:flutter/material.dart';






class EarningsScreen extends StatefulWidget {
  const EarningsScreen({
    super.key,
    this.repository,
  });

  final EarningsRepository? repository;

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  late final EarningsRepository _repository;

  EarningsData? _earnings;

  bool _isLoading = true;
  bool _isWithdrawing = false;

  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();

    _repository =
        widget.repository ?? EarningsMockRepository();

    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _repository.getEarnings(
        period: _selectedPeriod,
      );

      if (!mounted) return;

      setState(() {
        _earnings = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load earnings',
          ),
        ),
      );
    }
  }

  Future<void> _withdraw() async {
    if (_earnings == null) return;

    if (_earnings!.totalEarnings <= 0) {
      return;
    }

    setState(() {
      _isWithdrawing = true;
    });

    try {
      await _repository.withdrawToBank(
        amount: _earnings!.totalEarnings,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Withdrawal request submitted',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Withdrawal failed',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isWithdrawing = false;
        });
      }
    }
  }

  String _formatCurrency(double value) {
    final valueString = value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)},',
        );

    return '₹$valueString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF075C49),
                ),
              )
            : _earnings == null
                ? _buildError()
                : RefreshIndicator(
                    color: const Color(0xFF075C49),
                    onRefresh: _loadEarnings,
                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        110,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),

                          const SizedBox(height: 20),

                          _buildMainEarningsCard(),

                          const SizedBox(height: 20),

                          _buildStats(),

                          const SizedBox(height: 20),

                          _buildEarningsChart(),

                          const SizedBox(height: 20),

                          _buildTransactions(),
                        ],
                      ),
                    ),
                  ),
      ),

    
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'My Earnings',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF075C49),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Track your income from product sales',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: _showPeriodSelector,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0xFFE1E8E5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: Color(0xFF075C49),
                ),

                const SizedBox(width: 7),

                Text(
                  _periodText(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF075C49),
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF075C49),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _periodText() {
    switch (_selectedPeriod) {
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'This Week';
    }
  }

  // ----------------------------------------------------------
  // MAIN EARNINGS
  // ----------------------------------------------------------

  Widget _buildMainEarningsCard() {
    final data = _earnings!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF075C49),
            Color(0xFF064C3D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _formatCurrency(data.totalEarnings),
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF80D000)
                      .withOpacity(.22),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF9BE32A),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '+${data.percentageChange.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Color(0xFFB4ED55),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 9),

              Text(
                'vs last week',
                style: TextStyle(
                  color: Colors.white.withOpacity(.75),
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed:
                  _isWithdrawing ? null : _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF80D000),
                foregroundColor:
                    const Color(0xFF063D32),
                disabledBackgroundColor:
                    const Color(0xFF80D000)
                        .withOpacity(.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30),
                ),
              ),
              child: _isWithdrawing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF063D32),
                      ),
                    )
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_balance_rounded,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Withdraw to Bank',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATS
  // ----------------------------------------------------------

  Widget _buildStats() {
    final data = _earnings!;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_cart_rounded,
            iconColor: const Color(0xFF12A66A),
            backgroundColor:
                const Color(0xFFEAF8F1),
            value: '${data.totalOrders}',
            title: 'Orders',
            change: '+8%',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatCard(
            icon: Icons.layers_rounded,
            iconColor: const Color(0xFFF5A400),
            backgroundColor:
                const Color(0xFFFFF7E4),
            value: _formatCurrency(
              data.totalSales,
            ),
            title: 'Total Sales',
            change: '+15%',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatCard(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF1877E8),
            backgroundColor:
                const Color(0xFFEAF3FF),
            value: _formatCurrency(
              data.pendingPayout,
            ),
            title: 'Pending Payout',
            change: '+5%',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String value,
    required String title,
    required String change,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.65),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(height: 12),

          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF102D28),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF0B9B58),
                size: 15,
              ),
              const SizedBox(width: 3),
              Text(
                change,
                style: const TextStyle(
                  color: Color(0xFF07934F),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CHART
  // ----------------------------------------------------------

  Widget _buildEarningsChart() {
    final earnings = _earnings!.weeklyEarnings;

    double maxAmount = 0;

    for (final item in earnings) {
      if (item.amount > maxAmount) {
        maxAmount = item.amount;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        16,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE3EAE7),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Earnings Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF075C49),
                  ),
                ),
              ),

              Text(
                _periodText(),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF075C49),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 3),

              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 19,
                color: Color(0xFF075C49),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 250,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: earnings.map((item) {
                final isHighest =
                    item.amount == maxAmount;

                return Expanded(
                  child: _buildBar(
                    item,
                    maxAmount,
                    isHighest,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    DailyEarning item,
    double maxAmount,
    bool isHighest,
  ) {
    final ratio =
        maxAmount == 0
            ? 0.0
            : item.amount / maxAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [
          if (isHighest)
            Container(
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF12A66A),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Text(
                _formatCurrency(item.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor:
                    ratio.clamp(.12, 1.0),
                child: Container(
                  width: 34,
                  decoration: BoxDecoration(
                    color: isHighest
                        ? const Color(0xFF12A66A)
                        : const Color(0xFFDDF5E9),
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 9),

          Text(
            item.day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isHighest
                  ? FontWeight.w800
                  : FontWeight.w500,
              color: isHighest
                  ? const Color(0xFF075C49)
                  : Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            item.date,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isHighest
                  ? FontWeight.w700
                  : FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TRANSACTIONS
  // ----------------------------------------------------------

  Widget _buildTransactions() {
    final transactions = _earnings!.transactions;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE3EAE7),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              16,
              16,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF075C49),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    // Later:
                    // Navigate to complete
                    // transaction history.
                  },
                  child: const Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF075C49),
                          fontWeight:
                              FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF075C49),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: Color(0xFFE9EEEC),
          ),

          ...transactions.map(
            (transaction) =>
                _buildTransaction(transaction),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction(
    EarningTransaction transaction,
  ) {
    final isCredit = transaction.isCredit;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE9EEEC),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFFE8F8F0)
                  : const Color(0xFFFFEEEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit
                  ? Icons.call_received_rounded
                  : Icons.call_made_rounded,
              color: isCredit
                  ? const Color(0xFF0B9B58)
                  : const Color(0xFFF04444),
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF27364A),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  transaction.transactionId == null
                      ? transaction.date
                      : '${transaction.date}  •  Txn: ${transaction.transactionId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '${isCredit ? '+' : '-'} ${_formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isCredit
                  ? const Color(0xFF0B9B58)
                  : const Color(0xFFF04444),
            ),
          ),

          const SizedBox(width: 3),

          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PERIOD SELECTOR
  // ----------------------------------------------------------

  void _showPeriodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Period',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF075C49),
                  ),
                ),

                const SizedBox(height: 15),

                _periodOption(
                  'week',
                  'This Week',
                ),

                _periodOption(
                  'month',
                  'This Month',
                ),

                _periodOption(
                  'year',
                  'This Year',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _periodOption(
    String value,
    String title,
  ) {
    final selected =
        _selectedPeriod == value;

    return ListTile(
      onTap: () {
        Navigator.pop(context);

        setState(() {
          _selectedPeriod = value;
        });

        _loadEarnings();
      },
      leading: Icon(
        selected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: const Color(0xFF075C49),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ERROR
  // ----------------------------------------------------------

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 50,
            color: Colors.grey,
          ),

          const SizedBox(height: 15),

          const Text(
            'Unable to load earnings',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _loadEarnings,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

}