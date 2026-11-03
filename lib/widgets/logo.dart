import 'package:flutter/material.dart';
import '../strings.dart';

class GameLogo extends StatelessWidget {
  final double width;
  const GameLogo({super.key, this.width = 260});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Mesma grafia da pasta no GitHub (com maiúsculas)
    final path =
        s.pt ? 'Assets/Images/logo_pt.png' : 'Assets/Images/logo_en.png';
    return Image.asset(
      path,
      width: width,
      fit: BoxFit.contain,
      semanticLabel: s.appName,
      errorBuilder: (_, __, ___) => Text(
        s.appName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: width / 8, color: Colors.white),
      ),
    );
  }
}
