import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart'; // importa o GameTitle
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Exibe a tela de splash por 3 segundos, depois vai para a home
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F4B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nome do jogo em destaque (logo estilizado)
            const GameTitle('Guess Hunter'),
            const SizedBox(height: 40),
            // Barra de loading (apenas visual, frisa o nome do jogo)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3FA9F5)),
              strokeWidth: 4,
            ),
            const SizedBox(height: 24),
            const Text(
              'Carregando...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9FD3FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
