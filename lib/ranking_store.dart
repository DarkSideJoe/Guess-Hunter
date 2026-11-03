import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RankEntry {
  final String name;
  final int points;
  RankEntry(this.name, this.points);

  Map<String, dynamic> toJson() => {'name': name, 'points': points};

  factory RankEntry.fromJson(Map<String, dynamic> j) =>
      RankEntry(j['name'] as String, j['points'] as int);
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

  // Devolve a posição (1 a 10) ou 0 se não entrou no top
  static Future<int> add(String levelId, String name, int points) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load(levelId);
    final entry = RankEntry(name, points);
    list.add(entry);
    list.sort((a, b) => b.points.compareTo(a.points));
    final top = list.take(maxEntries).toList();
    await prefs.setString(
        'ranking_$levelId', jsonEncode(top.map((e) => e.toJson()).toList()));
    final pos = top.indexOf(entry);
    return pos == -1 ? 0 : pos + 1;
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
