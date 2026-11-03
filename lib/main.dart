import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'audio.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Trava a orientação do jogo apenas na vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppAudio.instance.init();
  runApp(const GuessHunterApp());
}

/// Nome do jogo em destaque: branco com contorno avermelhado e tamanho maior
class GameTitle extends StatelessWidget {
  final String text;
  const GameTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.redAccent,
      ),
    );
  }
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
      localeResolutionCallback: (locale, supported) {
        if (locale != null && locale.languageCode == 'pt') {
          return const Locale('pt');
        }
        return const Locale('en');
      },
      home: const SplashScreen(),
    );
  }
}
