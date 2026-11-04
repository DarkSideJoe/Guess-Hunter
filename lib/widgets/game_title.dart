import 'package:flutter/material.dart';

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
        // Importante: não usar "color" junto com "foreground"
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.redAccent,
      ),
    );
  }
}
