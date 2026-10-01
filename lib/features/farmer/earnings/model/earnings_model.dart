class EarningsData {
  final double totalEarnings;
  final double totalSales;
  final double pendingPayout;
  final int totalOrders;
  final double percentageChange;
  final List<DailyEarning> weeklyEarnings;
  final List<EarningTransaction> transactions;

  EarningsData({
    required this.totalEarnings,
    required this.totalSales,
    required this.pendingPayout,
    required this.totalOrders,
    required this.percentageChange,
    required this.weeklyEarnings,
    required this.transactions,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      totalSales: (json['total_sales'] ?? 0).toDouble(),
      pendingPayout: (json['pending_payout'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      percentageChange:
          (json['percentage_change'] ?? 0).toDouble(),

      weeklyEarnings: (json['weekly_earnings'] as List? ?? [])
          .map(
            (item) => DailyEarning.fromJson(item),
          )
          .toList(),

      transactions: (json['transactions'] as List? ?? [])
          .map(
            (item) => EarningTransaction.fromJson(item),
          )
          .toList(),
    );
  }
}

class DailyEarning {
  final String day;
  final String date;
  final double amount;

  DailyEarning({
    required this.day,
    required this.date,
    required this.amount,
  });

  factory DailyEarning.fromJson(Map<String, dynamic> json) {
    return DailyEarning(
      day: json['day'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class EarningTransaction {
  final String title;
  final String date;
  final String? transactionId;
  final double amount;
  final bool isCredit;

  EarningTransaction({
    required this.title,
    required this.date,
    this.transactionId,
    required this.amount,
    required this.isCredit,
  });

  factory EarningTransaction.fromJson(Map<String, dynamic> json) {
    return EarningTransaction(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      transactionId: json['transaction_id'],
      amount: (json['amount'] ?? 0).toDouble(),
      isCredit: json['is_credit'] ?? false,
    );
  }
}