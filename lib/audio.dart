import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAudio with WidgetsBindingObserver {
  AppAudio._();
  static final AppAudio instance = AppAudio._();

  // Mesma grafia da pasta no GitHub (com maiúsculas)
  static const String _dir = 'Assets/Audio/';

  final AudioPlayer _music = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();
  final ValueNotifier<bool> muted = ValueNotifier<bool>(false);

  bool _musicWanted = false;
  bool _started = false;

  Future<void> init() async {
    if (_started) return;
    _started = true;
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    // Sem prefixo, para usar o caminho completo dos arquivos
    AudioCache.instance.prefix = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      muted.value = prefs.getBool('muted') ?? false;
      await _music.setReleaseMode(ReleaseMode.loop);
      await _music.setVolume(0.3);
      await _sfx.setVolume(1.0);
    } catch (_) {}
  }

  // Música de fundo
  Future<void> startMusic() async {
    _musicWanted = true;
    if (muted.value) return;
    try {
      await _music.play(AssetSource('${_dir}music.wav'));
    } catch (_) {}
  }

  Future<void> pauseMusic() async {
    try {
      await _music.pause();
    } catch (_) {}
  }

  Future<void> resumeMusic() async {
    if (!_musicWanted || muted.value) return;
    try {
      if (_music.state == PlayerState.paused) {
        await _music.resume();
      } else {
        await _music.play(AssetSource('${_dir}music.wav'));
      }
    } catch (_) {}
  }

  // Efeitos sonoros
  Future<void> _play(String file) async {
    if (muted.value) return;
    try {
      await _sfx.stop();
      await _sfx.play(AssetSource('$_dir$file'));
    } catch (_) {}
  }

  Future<void> success() => _play('success.wav');
  Future<void> fail() => _play('fail.wav');
  Future<void> penalty() => _play('penalty.wav');
  Future<void> hint() => _play('hint.wav');

  // Liga e desliga todo o som
  Future<void> toggleMute() async {
    muted.value = !muted.value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('muted', muted.value);
    } catch (_) {}
    if (muted.value) {
      await pauseMusic();
      try {
        await _sfx.stop();
      } catch (_) {}
    } else {
      await resumeMusic();
    }
  }

  // Pausa a música quando o app vai para segundo plano
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeMusic();
    } else {
      pauseMusic();
    }
  }
}
