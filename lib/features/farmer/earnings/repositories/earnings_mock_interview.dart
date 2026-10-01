import 'package:farmdirect/features/farmer/earnings/repositories/earnings_repositories.dart';
import 'package:farmdirect/features/farmer/earnings/model/earnings_model.dart';


class EarningsMockRepository implements EarningsRepository {
  @override
  Future<EarningsData> getEarnings({
    String period = 'week',
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return EarningsData(
      totalEarnings: 145600,
      totalSales: 162400,
      pendingPayout: 16800,
      totalOrders: 24,
      percentageChange: 12,

      weeklyEarnings: [
        DailyEarning(
          day: 'Mon',
          date: '6 Oct',
          amount: 12000,
        ),
        DailyEarning(
          day: 'Tue',
          date: '7 Oct',
          amount: 20000,
        ),
        DailyEarning(
          day: 'Wed',
          date: '8 Oct',
          amount: 16000,
        ),
        DailyEarning(
          day: 'Thu',
          date: '9 Oct',
          amount: 28400,
        ),
        DailyEarning(
          day: 'Fri',
          date: '10 Oct',
          amount: 18000,
        ),
        DailyEarning(
          day: 'Sat',
          date: '11 Oct',
          amount: 22000,
        ),
        DailyEarning(
          day: 'Sun',
          date: '12 Oct',
          amount: 24500,
        ),
      ],

      transactions: [
        EarningTransaction(
          title: 'Transfer to State Bank of India',
          date: '12 Oct, 2026',
          transactionId: '#SBI-09432',
          amount: 25000,
          isCredit: false,
        ),
        EarningTransaction(
          title: 'Escrow Payout #FD1201',
          date: '10 Oct, 2026',
          amount: 12400,
          isCredit: true,
        ),
      ],
    );
  }

  @override
  Future<void> withdrawToBank({
    required double amount,
  }) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    // Later:
    // POST /earnings/withdraw
  }
}