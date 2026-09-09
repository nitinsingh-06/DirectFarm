import 'package:farmdirect/Authentification/screens/splash_screen.dart';
import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:farmdirect/core/provider/theme_provider.dart';
import 'package:farmdirect/core/theme/app_theme.dart';
import 'package:farmdirect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final profileProvider = ProfileProvider();

  await profileProvider.loadProfile();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BuyerProfileProvider()..loadProfile()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: themeProvider.themeMode,

      home: const SplashScreen(),
    );
  }
}