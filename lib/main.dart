import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';

void main() => runApp(const GuessHunterApp());

class GuessHunterApp extends StatelessWidget {
  const GuessHunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1F4B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A00),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('en')],
      // Se o idioma do celular não for português, usa inglês
      localeResolutionCallback: (locale, supported) {
        if (locale != null && locale.languageCode == 'pt') {
          return const Locale('pt');
        }
        return const Locale('en');
      },
      home: const HomeScreen(),
    );
  }
}
