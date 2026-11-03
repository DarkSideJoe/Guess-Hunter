import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio.dart';
import '../game_logic.dart';
import '../ranking_store.dart';
import '../strings.dart';
import '../widgets/popups.dart';
import 'ranking_screen.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  final String playerName;
  const GameScreen({super.key, required this.level, required this.playerName});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game;
  final TextEditingController _input = TextEditingController();
  String _hint = '';
  Timer? _ticker;

  String get _levelId => const {
        Level.easy: 'easy',
        Level.normal: 'normal',
        Level.hard: 'hard',
        Level.veryHard: 'veryhard',
      }[widget.level]!;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    game = Game(widget.level);
    _hint = '';
    _input.clear();
    _ticker?.cancel();
    // Atualiza o cronômetro na tela a cada segundo
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !game.over) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _input.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = S.of(context);
    final value = int.tryParse(_input.text.trim());
    if (value == null) {
      setState(() => _hint = s.invalid);
      return;
    }
    _input.clear();
    final result = game.guess(value);

    switch (result) {
      case GuessResult.tooHigh:
        AppAudio.instance.hint();
        setState(() => _hint = s.tooHigh);
        break;
      case GuessResult.tooLow:
        AppAudio.instance.hint();
        setState(() => _hint = s.tooLow);
        break;
      case GuessResult.outside:
        setState(() => _hint = s.penaltyBody);
        await showPenaltyPopup(context);
        break;
      case GuessResult.gameOver:
        setState(() {});
        _ticker?.cancel();
        final choice = await showGameOverPopup(context, game.secret);
        _handleChoice(choice);
        break;
      case GuessResult.win:
        setState(() {});
        _ticker?.cancel();

        final score = game.score();
        final pos = await RankingStore.add(_levelId, widget.playerName, score);
        if (!mounted) return;

        // 1. Tela de resultado com OK circular (música de vitória toca aqui)
        await showResultPopup(context,
            secret: game.secret,
            used: game.attemptsUsed,
            secs: game.seconds,
            score: score,
            position: pos);
        if (!mounted) return;

        // 2. Se bateu recorde, grava o nome (música de vitória também toca)
        if (pos > 0) {
          final nomeDigitado = await showNameInputPopup(context);
          final nomeFinal = (nomeDigitado != null && nomeDigitado.isNotEmpty)
              ? nomeDigitado
              : 'Anônimo';
          await RankingStore.saveName(nomeFinal);
          if (!mounted) return;
        }

        // 3. Tela com opções (novo jogo, ranking, home)
        final choice = await showOptionsPopup(context);
        _handleChoice(choice);
        break;
    }
  }

  void _handleChoice(String? choice) {
    if (!mounted) return;
    if (choice == 'again') {
      setState(_newGame);
    } else if (choice == 'ranking') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RankingScreen(initialLevel: widget.level)));
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmQuit() async {
    final s = S.of(context);
    if (game.over) return true;
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.quitTitle),
        content: Text(s.quitBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(s.no)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(s.yes)),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await _confirmQuit();
        if (ok && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('${s.appName} - ${s.levelName(_levelId)}'),
          backgroundColor: Colors.transparent,
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: AppAudio.instance.muted,
              builder: (_, muted, __) => IconButton(
                tooltip: muted ? s.soundOn : s.soundOff,
                icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                onPressed: () => AppAudio.instance.toggleMute(),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(s.range,
                    style: const TextStyle(
                        fontSize: 20, color: Color(0xFF9FD3FF))),
                Text(
                  '${game.low}  -  ${game.high}',
                  style: const TextStyle(
                      fontSize: 56, fontWeight: FontWeight.bold),
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat(s.attempts, '${game.attemptsLeft}'),
                    _stat(s.time, '${game.seconds}s'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: Text(_hint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, color: Color(0xFFB3E5FC))),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextField(
                        controller: _input,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 32),
                        decoration: InputDecoration(
                          hintText: s.guessHint,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          minimumSize: const Size(56, 56),
                        ),
                        child: const Icon(
                          Icons.send,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF9FD3FF))),
          Text(value,
              style:
                  const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        ],
      );
}
