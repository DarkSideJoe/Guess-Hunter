import 'package:flutter/material.dart';
import '../audio.dart';
import '../game_logic.dart';
import '../widgets/logo.dart';
import '../widgets/game_title.dart';
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

  // Botão estilizado para cada nível de dificuldade
  Widget _buildLevelButton(Level level, String id, BuildContext context) {
    final s = S.of(context);
    final cfg = levelConfigs[level]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nome da dificuldade: preenchimento branco + contorno preto
              Stack(
                children: [
                  // Texto de trás: contorno preto
                  Text(
                    s.levelName(id),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                  ),
                  // Texto da frente: preenchimento branco
                  Text(
                    s.levelName(id),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Características abaixo, menor
              Text(
                '${cfg.max}  •  ${cfg.attempts} ${s.attempts.toLowerCase()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
        title: GameLogo(width: 120), // logo maior na AppBar
        backgroundColor: Colors.transparent,
        centerTitle: true,
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
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                s.pickLevel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 24),
              for (final e in levels.entries)
                _buildLevelButton(e.key, e.value, context),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RankingScreen())),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
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
