import 'dart:math';

enum Level { easy, normal, hard, veryHard }

class LevelConfig {
  final int max;
  final int attempts;
  final int base;
  final int attemptBonus;
  const LevelConfig(this.max, this.attempts, this.base, this.attemptBonus);
}

const Map<Level, LevelConfig> levelConfigs = {
  Level.easy: LevelConfig(100, 15, 1000, 100),
  Level.normal: LevelConfig(500, 12, 1500, 120),
  Level.hard: LevelConfig(1000, 15, 2000, 150),
  Level.veryHard: LevelConfig(2000, 11, 3000, 200),
};

enum GuessResult { win, tooHigh, tooLow, outside, gameOver }

class Game {
  final Level level;
  late final int secret;
  int low = 0;
  late int high;
  late int attemptsLeft;
  int attemptsUsed = 0;
  final Stopwatch stopwatch = Stopwatch();
  bool over = false;

  static const int penalty = 2;

  Game(this.level) {
    final cfg = levelConfigs[level]!;
    secret = Random().nextInt(cfg.max + 1);
    high = cfg.max;
    attemptsLeft = cfg.attempts;
    stopwatch.start();
  }

  int get seconds => stopwatch.elapsed.inSeconds;

  GuessResult guess(int value) {
    // Chute fora do intervalo atual: perde duas tentativas, limites intactos
    if (value < low || value > high) {
      attemptsLeft = max(0, attemptsLeft - penalty);
      attemptsUsed += penalty;
      if (attemptsLeft == 0) {
        over = true;
        stopwatch.stop();
        return GuessResult.gameOver;
      }
      return GuessResult.outside;
    }

    attemptsLeft -= 1;
    attemptsUsed += 1;

    if (value == secret) {
      over = true;
      stopwatch.stop();
      return GuessResult.win;
    }

    // Limites cumulativos: só encurtam, nunca resetam
    final tooHigh = value > secret;
    if (tooHigh) {
      high = min(high, value);
    } else {
      low = max(low, value);
    }

    if (attemptsLeft == 0) {
      over = true;
      stopwatch.stop();
      return GuessResult.gameOver;
    }
    return tooHigh ? GuessResult.tooHigh : GuessResult.tooLow;
  }

  // Pontuação só para vitória. Tentativas pesam mais, tempo é desempate leve.
  int score() {
    final cfg = levelConfigs[level]!;
    final timePenalty = min(90, seconds ~/ 10);
    return cfg.base + attemptsLeft * cfg.attemptBonus - timePenalty;
  }
}
