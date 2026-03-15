import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MechanicApp(),
    ),
  );
}

class MechanicApp extends StatelessWidget {
  const MechanicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zerfix Mechanic',
      theme: AppTheme.lightTheme,
      
      // Localization setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('hi', ''), // Hindi
        Locale('en', ''), // English
      ],
      locale: const Locale('hi', ''), // Default to Hindi
      
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}