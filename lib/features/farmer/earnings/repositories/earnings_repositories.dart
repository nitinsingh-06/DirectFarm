import 'package:farmdirect/features/farmer/earnings/model/earnings_model.dart';


abstract class EarningsRepository {
  Future<EarningsData> getEarnings({
    String period = 'week',
  });

  Future<void> withdrawToBank({
    required double amount,
  });
}