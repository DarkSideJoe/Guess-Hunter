import 'package:flutter/material.dart';
import '../game_logic.dart';
import '../ranking_store.dart';
import '../strings.dart';

class RankingScreen extends StatefulWidget {
  final Level initialLevel;
  const RankingScreen({super.key, this.initialLevel = Level.easy});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late Level _level = widget.initialLevel;
  List<RankEntry> _entries = [];

  static const ids = {
    Level.easy: 'easy',
    Level.normal: 'normal',
    Level.hard: 'hard',
    Level.veryHard: 'veryhard',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await RankingStore.load(ids[_level]!);
    if (mounted) setState(() => _entries = list);
  }

  // Retorna a cor da medalha para as 3 primeiras colocações
  Color _medalColor(int position) {
    switch (position) {
      case 1: return const Color(0xFFFFD700); // Ouro
      case 2: return const Color(0xFFC0C0C0); // Prata
      case 3: return const Color(0xFFCD7F32); // Bronze
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.ranking),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<Level>(
                showSelectedIcon: false,
                segments: [
                  for (final l in Level.values)
                    ButtonSegment(
                      value: l,
                      label: Text(s.levelName(ids[l]!),
                          style: const TextStyle(fontSize: 12)),
                    ),
                ],
                selected: {_level},
                onSelectionChanged: (v) {
                  setState(() => _level = v.first);
                  _load();
                },
              ),
            ),
            Expanded(
              child: _entries.isEmpty
                  ? Center(child: Text(s.emptyRanking))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (_, i) {
                        final position = i + 1;
                        final entry = _entries[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: _medalColor(position),
                            child: Text('$position',
                                style: TextStyle(
                                  color: position <= 3 ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  entry.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${entry.points} pts',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${entry.time}s',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9FD3FF),
                                ),
                              ),
                              Text(
                                '${entry.attempts} tent.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9FD3FF),
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
