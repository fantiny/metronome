import '../entities/metronome_settings.dart';

abstract class AudioOutput {
  Future<void> loadSounds();
  Future<void> playBeat({
    required bool isAccent,
    required SoundType sound,
    required double volume,
    required bool isMuted,
  });
  void dispose();
}
