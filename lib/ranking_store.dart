import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RankEntry {
  final String name;
  final int points;
  final int time;
  final int attempts;

  const RankEntry({
    required this.name,
    required this.points,
    required this.time,
    required this.attempts,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'points': points,
    'time': time,
    'attempts': attempts,
  };

  factory RankEntry.fromJson(Map<String, dynamic> j) => RankEntry(
    name: j['name'] as String? ?? '',
    points: j['points'] as int? ?? 0,
    time: j['time'] as int? ?? 0,
    attempts: j['attempts'] as int? ?? 0,
  );
}

class RankingStore {
  static const int maxEntries = 10;

  static Future<List<RankEntry>> load(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('ranking_$levelId');
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List)
        .map((e) => RankEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  // Adiciona entrada com todos os dados. Retorna posição (1..10) ou 0 se não entrou.
  static Future<int> add({
    required String levelId,
    required String name,
    required int points,
    required int time,
    required int attempts,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load(levelId);
    final entry = RankEntry(
      name: name,
      points: points,
      time: time,
      attempts: attempts,
    );
    list.add(entry);
    list.sort((a, b) => b.points.compareTo(a.points));
    final top = list.take(maxEntries).toList();
    await prefs.setString(
      'ranking_$levelId',
      jsonEncode(top.map((e) => e.toJson()).toList()),
    );
    final pos = top.indexOf(entry);
    return pos == -1 ? 0 : pos + 1;
  }

  // Atualiza o nome de uma entrada já salva no ranking (por posição 1-based)
  static Future<void> updateName(String levelId, int position, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load(levelId);
    if (position < 1 || position > list.length) return;
    final entry = list[position - 1];
    list[position - 1] = RankEntry(
      name: name,
      points: entry.points,
      time: entry.time,
      attempts: entry.attempts,
    );
    await prefs.setString(
      'ranking_$levelId',
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<String> lastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_name') ?? '';
  }

  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_name', name);
  }
}
