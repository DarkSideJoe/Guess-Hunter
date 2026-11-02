import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'audio.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAudio.instance.init();
  runApp(const GuessHunterApp());
}

class GuessHunterApp extends StatelessWidget {
  const GuessHunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3FA9F5),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF3FA9F5),
      onPrimary: const Color(0xFF0B1F4B),
    );

    return MaterialApp(
      title: 'Guess Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'TitanOne',
        scaffoldBackgroundColor: const Color(0xFF0B1F4B),
        colorScheme: scheme,
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
