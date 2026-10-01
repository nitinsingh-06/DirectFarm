
// import 'package:farmdirect/features/farmer/earnings/model/earnings_model.dart';
// import 'package:farmdirect/features/farmer/earnings/repositories/earnings_repositories.dart';

// class EarningsApiRepository
//     implements EarningsRepository {

//   final String baseUrl;
//   final String idToken;

//   EarningsApiRepository({
//     required this.baseUrl,
//     required this.idToken,
//   });

//   @override
//   Future<EarningsData> getEarnings({
//     String period = 'week',
//   }) async {

//     // Your ApiService here
//     //
//     // GET:
//     // /earnings/me?period=week

//     final response = await apiGet(
//       '$baseUrl/earnings/me?period=$period',
//       idToken,
//     );

//     return EarningsData.fromJson(response);
//   }

//   @override
//   Future<void> withdrawToBank({
//     required double amount,
//   }) async {

//     // POST:
//     // /earnings/withdraw

//     await apiPost(
//       '$baseUrl/earnings/withdraw',
//       {
//         'amount': amount,
//       },
//       idToken,
//     );
//   }
// }