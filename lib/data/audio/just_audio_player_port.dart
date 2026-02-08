import 'package:just_audio/just_audio.dart';

import 'audio_player_port.dart';

class JustAudioPlayerPort implements AudioPlayerPort {
  final AudioPlayer _player;

  JustAudioPlayerPort([AudioPlayer? player]) : _player = player ?? AudioPlayer();

  @override
  Future<void> setAsset(String assetPath) async {
    await _player.setAsset(assetPath);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
