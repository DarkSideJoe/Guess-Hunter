import 'package:flutter/widgets.dart';

class S {
  final bool pt;
  S(this.pt);

  static S of(BuildContext context) =>
      S(Localizations.localeOf(context).languageCode == 'pt');

  String get appName => pt ? 'Caça-Número' : 'Guess Hunter';
  String get whoPlays => pt ? 'Quem está jogando?' : 'Who is playing?';
  String get nameHint => pt ? 'Seu nome' : 'Your name';
  String get pickLevel => pt ? 'Escolha o nível' : 'Pick a level';
  String get ranking => 'Ranking';
  String get play => pt ? 'Jogar' : 'Play';
  String get guessHint => pt ? 'Seu chute' : 'Your guess';
  String get guessButton => pt ? 'Chutar' : 'Guess';
  String get range => pt ? 'Intervalo' : 'Range';
  String get attempts => pt ? 'Tentativas' : 'Attempts';
  String get time => pt ? 'Tempo' : 'Time';
  String get tooHigh => pt ? 'Menor! O número é menor que o seu chute.' : 'Lower! The number is below your guess.';
  String get tooLow => pt ? 'Maior! O número é maior que o seu chute.' : 'Higher! The number is above your guess.';
  String get invalid => pt ? 'Digite um número válido.' : 'Enter a valid number.';
  String get penaltyTitle => pt ? 'Fora do intervalo!' : 'Outside the range!';
  String get penaltyBody => pt ? 'Você perdeu 2 tentativas por chutar fora do intervalo.' : 'You lost 2 attempts for guessing outside the range.';
  String get winTitle => pt ? 'Você acertou!' : 'You got it!';
  String winBody(int secret, int used, int secs, int score) => pt
      ? 'O número era $secret.\nTentativas usadas: $used\nTempo: ${secs}s\nPontuação: $score'
      : 'The number was $secret.\nAttempts used: $used\nTime: ${secs}s\nScore: $score';
  String get gameOverTitle => 'Game over';
  String gameOverBody(int secret) => pt ? 'As tentativas acabaram. O número era $secret.' : 'You ran out of attempts. The number was $secret.';
  String get playAgain => pt ? 'Jogar de novo' : 'Play again';
  String get home => pt ? 'Início' : 'Home';
  String get viewRanking => pt ? 'Ver ranking' : 'View ranking';
  String get ok => 'OK';
  String get emptyRanking => pt ? 'Ainda não há ranking neste nível.' : 'There is no ranking on this level yet.';
  String get nameRequired => pt ? 'Digite seu nome para começar.' : 'Enter your name to start.';
  String get quitTitle => pt ? 'Sair da partida?' : 'Leave the game?';
  String get quitBody => pt ? 'O progresso desta partida será perdido.' : 'Your progress in this game will be lost.';
  String get yes => pt ? 'Sim' : 'Yes';
  String get no => pt ? 'Não' : 'No';

  // Créditos e som
  String get credits => pt ? 'Créditos' : 'Credits';
  String get createdBy => pt ? 'Criado por' : 'Created by';
  String get author => 'Joe Karv';
  String get version => pt ? 'Versão 1.0.0' : 'Version 1.0.0';
  String get close => pt ? 'Fechar' : 'Close';
  String get soundOn => pt ? 'Ligar som' : 'Sound on';
  String get soundOff => pt ? 'Desligar som' : 'Sound off';

  String levelName(String id) {
    switch (id) {
      case 'easy': return pt ? 'Fácil' : 'Easy';
      case 'normal': return 'Normal';
      case 'hard': return pt ? 'Difícil' : 'Hard';
      default: return 'Very Hard';
    }
  }
}
