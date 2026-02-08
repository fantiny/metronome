import '../../domain/entities/metronome_settings.dart';
import '../../domain/services/audio_output.dart';
import 'audio_player_port.dart';
import 'just_audio_player_port.dart';

class JustAudioOutput implements AudioOutput {
  static const String clickAsset = 'assets/sounds/click.wav';
  static const String woodAsset = 'assets/sounds/wood.wav';
  static const double accentBoost = 1.2;

  final AudioPlayerPort _clickPlayer;
  final AudioPlayerPort _woodPlayer;
  bool _loaded = false;

  JustAudioOutput({
    AudioPlayerPort? clickPlayer,
    AudioPlayerPort? woodPlayer,
  })  : _clickPlayer = clickPlayer ?? JustAudioPlayerPort(),
        _woodPlayer = woodPlayer ?? JustAudioPlayerPort();

  @override
  Future<void> loadSounds() async {
    await _clickPlayer.setAsset(clickAsset);
    await _woodPlayer.setAsset(woodAsset);
    _loaded = true;
  }

  @override
  Future<void> playBeat({
    required bool isAccent,
    required SoundType sound,
    required double volume,
    required bool isMuted,
  }) async {
    if (isMuted) {
      return;
    }
    if (!_loaded) {
      await loadSounds();
    }
    final player = sound == SoundType.click ? _clickPlayer : _woodPlayer;
    final effectiveVolume = _clampVolume(
      volume * (isAccent ? accentBoost : 1.0),
    );

    await player.setVolume(effectiveVolume);
    await player.seek(Duration.zero);
    await player.play();
  }

  @override
  void dispose() {
    _clickPlayer.dispose();
    _woodPlayer.dispose();
  }

  double _clampVolume(double volume) {
    if (volume < 0) {
      return 0;
    }
    if (volume > 1) {
      return 1;
    }
    return volume;
  }
}
