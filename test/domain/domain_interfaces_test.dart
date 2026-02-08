import 'package:flutter_test/flutter_test.dart';
import 'package:rythemtick/domain/repositories/settings_repository.dart';
import 'package:rythemtick/domain/services/audio_output.dart';
import 'package:rythemtick/domain/services/wake_lock_service.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';

class _SettingsRepositoryStub implements SettingsRepository {
  @override
  Future<MetronomeSettings> load() async {
    return MetronomeSettings.defaults();
  }

  @override
  Future<void> save(MetronomeSettings settings) async {}
}

class _AudioOutputStub implements AudioOutput {
  @override
  Future<void> loadSounds() async {}

  @override
  Future<void> playBeat({
    required bool isAccent,
    required SoundType sound,
    required double volume,
    required bool isMuted,
  }) async {}

  @override
  void dispose() {}
}

class _WakeLockStub implements WakeLockService {
  @override
  Future<void> setEnabled(bool enabled) async {}
}

void main() {
  test('SettingsRepository 接口可用', () async {
    final repo = _SettingsRepositoryStub();
    final settings = await repo.load();

    expect(settings, isA<MetronomeSettings>());
  });

  test('AudioOutput 接口可用', () async {
    final audio = _AudioOutputStub();

    await audio.loadSounds();
    await audio.playBeat(
      isAccent: true,
      sound: SoundType.click,
      volume: 1.0,
      isMuted: false,
    );

    audio.dispose();
  });

  test('WakeLockService 接口可用', () async {
    final wakeLock = _WakeLockStub();

    await wakeLock.setEnabled(true);
    await wakeLock.setEnabled(false);
  });
}
