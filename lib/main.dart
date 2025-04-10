import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/core/theme.dart';
import 'package:subs_track/views/home/home_view.dart';
import 'package:subs_track/views/registration/subscription_registration_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      locale: const Locale('ko', 'KR'),
      home: HomeView(),
      routes: {
        '/home': (context) => const HomeView(),
        '/registration': (context) => const SubscriptionRegistrationView(),
      },
    );
  }
}
