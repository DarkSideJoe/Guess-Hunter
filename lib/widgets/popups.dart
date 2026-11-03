import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../audio.dart';
import '../strings.dart';

// Pop-up de penalidade: chute fora do intervalo
Future<void> showPenaltyPopup(BuildContext context) {
  final s = S.of(context);
  AppAudio.instance.penalty();
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF3B3F9E),
      title: Text('⚠️ ${s.penaltyTitle}'),
      content: Text(s.penaltyBody),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(), child: Text(s.ok)),
      ],
    ),
  );
}

// Pop-up de game over
Future<String?> showGameOverPopup(BuildContext context, int secret) {
  final s = S.of(context);
  AppAudio.instance.fail();
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF4A2A6B),
      title: Text('💥 ${s.gameOverTitle}'),
      content: Text(s.gameOverBody(secret)),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop('home'),
            child: Text(s.home)),
        FilledButton(
            onPressed: () => Navigator.of(ctx).pop('again'),
            child: Text(s.playAgain)),
      ],
    ),
  );
}

// Pop-up para digitar o nome quando bater um recorde (campo começa vazio)
// Toca música de vitória também
Future<String?> showNameInputPopup(BuildContext context) {
  final s = S.of(context);
  final controller = TextEditingController(); // começa sempre vazio
  AppAudio.instance.success(); // música de vitória nesta tela
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final nome = controller.text.trim();
        final podeConfirmar = nome.length >= 2;

        return AlertDialog(
          backgroundColor: const Color(0xFF3B3F9E),
          title: Text('🏆 Novo recorde!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.nameRequired),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLength: 16,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: s.nameHint,
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (nome.isNotEmpty && nome.length < 2)
                const Text(
                  'Digite pelo menos 2 letras.',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null), // não grava
              child: Text('Cancelar'),
            ),
            FilledButton(
              onPressed: podeConfirmar
                  ? () => Navigator.of(ctx).pop(controller.text.trim())
                  : null,
              child: Text(s.ok),
            ),
          ],
        );
      },
    ),
  );
}

// Pop-up de resultado com OK circular (música de vitória já tocou ao abrir)
Future<void> showResultPopup(BuildContext context,
    {required int secret,
    required int used,
    required int secs,
    required int score,
    required int position}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ResultDialog(
        secret: secret, used: used, secs: secs, score: score, position: position),
  );
}

class _ResultDialog extends StatefulWidget {
  final int secret, used, secs, score, position;
  const _ResultDialog(
      {required this.secret,
      required this.used,
      required this.secs,
      required this.score,
      required this.position});
  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog> {
  final ConfettiController _left =
      ConfettiController(duration: const Duration(seconds: 4));
  final ConfettiController _right =
      ConfettiController(duration: const Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
    AppAudio.instance.success(); // música de vitória toca aqui
    _left.play();
    _right.play();
  }

  @override
  void dispose() {
    _left.dispose();
    _right.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        AlertDialog(
          backgroundColor: const Color(0xFF0B6E4F),
          title: Text('🎆 ${s.winTitle} 🎇'),
          content: Text(
            s.winBody(widget.secret, widget.used, widget.secs, widget.score) +
                (widget.position > 0
                    ? '\n#${widget.position} ${s.ranking}'
                    : ''),
          ),
          actions: [
            // Só um botão circular OK
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(56, 56),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0B6E4F),
                ),
                child: const Icon(Icons.check, size: 24),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _left,
            blastDirection: pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _right,
            blastDirection: 3 * pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }
}

// Pop-up de opções após o resultado (novo jogo, ranking, home)
Future<String?> showOptionsPopup(BuildContext context) {
  final s = S.of(context);
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0B6E4F),
      title: Text('🏆 ${s.winTitle}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('O que você deseja fazer?'),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop('again'),
              child: Text(s.playAgain),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop('ranking'),
              child: Text(s.viewRanking),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop('home'),
              child: Text(s.home),
            ),
          ],
        ),
      ],
    ),
  );
}

// Pop-up de vitória antigo (mantido se precisar em outro lugar, mas não usado no novo fluxo)
Future<String?> showWinPopup(BuildContext context,
    {required int secret,
    required int used,
    required int secs,
    required int score,
    required int position}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _WinDialog(
        secret: secret,
        used: used,
        secs: secs,
        score: score,
        position: position),
  );
}

class _WinDialog extends StatefulWidget {
  final int secret, used, secs, score, position;
  const _WinDialog(
      {required this.secret,
      required this.used,
      required this.secs,
      required this.score,
      required this.position});
  @override
  State<_WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<_WinDialog> {
  final ConfettiController _left =
      ConfettiController(duration: const Duration(seconds: 4));
  final ConfettiController _right =
      ConfettiController(duration: const Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
    AppAudio.instance.success();
    _left.play();
    _right.play();
  }

  @override
  void dispose() {
    _left.dispose();
    _right.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        AlertDialog(
          backgroundColor: const Color(0xFF0B6E4F),
          title: Text('🎆 ${s.winTitle} 🎇'),
          content: Text(
            s.winBody(widget.secret, widget.used, widget.secs, widget.score) +
                (widget.position > 0
                    ? '\n#${widget.position} ${s.ranking}'
                    : ''),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop('home'),
                child: Text(s.home)),
            TextButton(
                onPressed: () => Navigator.of(context).pop('ranking'),
                child: Text(s.viewRanking)),
            FilledButton(
                onPressed: () => Navigator.of(context).pop('again'),
                child: Text(s.playAgain)),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _left,
            blastDirection: pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _right,
            blastDirection: 3 * pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }
}
