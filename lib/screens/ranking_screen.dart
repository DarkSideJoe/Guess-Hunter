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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.ranking), backgroundColor: Colors.transparent),
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
                      itemBuilder: (_, i) => ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(_entries[i].name,
                            style: const TextStyle(fontSize: 22)),
                        trailing: Text('${_entries[i].points}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
