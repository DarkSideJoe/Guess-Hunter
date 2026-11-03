import 'package:flutter/material.dart';
import '../audio.dart';
import '../game_logic.dart';
import '../main.dart'; // importa o GameTitle
import '../strings.dart';
import 'game_screen.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AppAudio.instance.startMusic();
  }

  void _start(Level level) async {
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GameScreen(level: level, playerName: ''),
    ));
  }

  void _showCredits() {
    final s = S.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: GameTitle(s.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(s.createdBy,
                style: const TextStyle(fontSize: 16, color: Color(0xFF9FD3FF))),
            Text(s.author, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 16),
            Text(s.version,
                style: const TextStyle(fontSize: 14, color: Color(0xFF9FD3FF))),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text(s.close)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final levels = {
      Level.easy: 'easy',
      Level.normal: 'normal',
      Level.hard: 'hard',
      Level.veryHard: 'veryhard',
    };
    return Scaffold(
      appBar: AppBar(
        title: GameTitle(s.appName),
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
          IconButton(
            tooltip: s.credits,
            icon: const Icon(Icons.info_outline),
            onPressed: _showCredits,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Text(s.pickLevel, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final e in levels.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FilledButton(
                    onPressed: () => _start(e.key),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        '${s.levelName(e.value)}  (0 - ${levelConfigs[e.key]!.max}, ${levelConfigs[e.key]!.attempts} ${s.attempts.toLowerCase()})',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RankingScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(s.ranking, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
