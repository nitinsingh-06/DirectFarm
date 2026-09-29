import 'package:farmdirect/Authentification/screens/splash_screen.dart';
import 'package:farmdirect/core/provider/address_provider.dart';
import 'package:farmdirect/core/provider/buyer_product_provider.dart';
import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:farmdirect/core/provider/langauge_provider.dart';
import 'package:farmdirect/core/provider/theme_provider.dart';
import 'package:farmdirect/firebase_options.dart';
import 'package:farmdirect/l10n/app_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider()..loadProfile(),
        ),

        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BuyerProfileProvider()..loadProfile(),
        ),

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BuyerProductProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // -----------------------------
      // LANGUAGE
      // -----------------------------
      locale: languageProvider.selectedLocale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],

      // -----------------------------
      // THEME
      // -----------------------------
      themeMode: themeProvider.themeMode,

      // -----------------------------
      // INITIAL SCREEN
      // -----------------------------
      home: const SplashScreen(),
    );
  }
}