import 'package:flutter/material.dart';
import '../audio.dart';
import '../game_logic.dart';
import '../ranking_store.dart';
import '../strings.dart';
import 'game_screen.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppAudio.instance.startMusic();
    RankingStore.lastName().then((n) {
      if (mounted) setState(() => _name.text = n);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _start(Level level) async {
    final s = S.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(s.nameRequired)));
      return;
    }
    await RankingStore.saveName(name);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GameScreen(level: level, playerName: name),
    ));
  }

  void _showCredits() {
    final s = S.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.credits, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.appName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Color(0xFF3FA9F5))),
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
        title: Text(s.appName),
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
              Text(s.whoPlays, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                maxLength: 16,
                decoration: InputDecoration(
                  hintText: s.nameHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
