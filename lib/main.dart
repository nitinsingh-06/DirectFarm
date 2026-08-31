import 'package:farmdirect/Authentification/screens/splash_screen.dart';
import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/core/provider/farmer_profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final profileProvider = ProfileProvider();

  await profileProvider.loadProfile();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BuyerProfileProvider()..loadProfile()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmDirect',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF075B47)),
      ),

      home: const SplashScreen(),
    );
  }
}
