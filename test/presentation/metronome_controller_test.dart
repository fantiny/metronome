import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rythemtick/domain/entities/beat_event.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';
import 'package:rythemtick/domain/repositories/settings_repository.dart';
import 'package:rythemtick/domain/services/audio_output.dart';
import 'package:rythemtick/domain/services/metronome_engine.dart';
import 'package:rythemtick/domain/services/wake_lock_service.dart';
import 'package:rythemtick/presentation/controllers/metronome_controller.dart';

class _FakeEngine implements MetronomeEngine {
  final StreamController<BeatEvent> controller =
      StreamController<BeatEvent>.broadcast(sync: true);
  bool started = false;
  int? lastBpm;
  int? lastBeatsPerBar;
  int setBpmCount = 0;

  @override
  Stream<BeatEvent> get beatStream => controller.stream;

  @override
  bool get isRunning => started;

  @override
  void start({required int bpm, required int beatsPerBar}) {
    started = true;
    lastBpm = bpm;
    lastBeatsPerBar = beatsPerBar;
  }

  @override
  void setBpm(int bpm) {
    setBpmCount += 1;
    lastBpm = bpm;
  }

  @override
  void stop() {
    started = false;
  }

  @override
  void dispose() {
    controller.close();
  }

  void emit(BeatEvent event) {
    controller.add(event);
  }
}

class _FakeAudioOutput implements AudioOutput {
  bool loaded = false;
  int playCount = 0;
  bool? lastAccent;
  SoundType? lastSound;
  double? lastVolume;
  bool? lastMuted;

  @override
  Future<void> loadSounds() async {
    loaded = true;
  }

  @override
  Future<void> playBeat({
    required bool isAccent,
    required SoundType sound,
    required double volume,
    required bool isMuted,
  }) async {
    playCount += 1;
    lastAccent = isAccent;
    lastSound = sound;
    lastVolume = volume;
    lastMuted = isMuted;
  }

  @override
  void dispose() {}
}

class _FakeSettingsRepository implements SettingsRepository {
  MetronomeSettings settings;

  _FakeSettingsRepository(this.settings);

  @override
  Future<MetronomeSettings> load() async => settings;

  @override
  Future<void> save(MetronomeSettings settings) async {
    this.settings = settings;
  }
}

class _FakeWakeLockService implements WakeLockService {
  final List<bool> calls = [];

  @override
  Future<void> setEnabled(bool enabled) async {
    calls.add(enabled);
  }
}

void main() {
  test('initialize 加载设置并预加载音效', () async {
    final engine = _FakeEngine();
    final audio = _FakeAudioOutput();
    final repo = _FakeSettingsRepository(
      MetronomeSettings.defaults().copyWith(bpm: 90),
    );
    final wakeLock = _FakeWakeLockService();

    final controller = MetronomeController(
      engine: engine,
      audioOutput: audio,
      settingsRepository: repo,
      wakeLockService: wakeLock,
    );

    await controller.initialize();

    expect(controller.settings.bpm, 90);
    expect(audio.loaded, true);
  });

  test('start 会启动引擎并启用防休眠', () async {
    final engine = _FakeEngine();
    final audio = _FakeAudioOutput();
    final repo = _FakeSettingsRepository(MetronomeSettings.defaults());
    final wakeLock = _FakeWakeLockService();

    final controller = MetronomeController(
      engine: engine,
      audioOutput: audio,
      settingsRepository: repo,
      wakeLockService: wakeLock,
    );

    await controller.initialize();
    await controller.start();

    expect(controller.isRunning, true);
    expect(engine.started, true);
    expect(engine.lastBpm, controller.settings.bpm);
    expect(wakeLock.calls.last, true);
  });

  test('stop 会停止并关闭防休眠', () async {
    final engine = _FakeEngine();
    final audio = _FakeAudioOutput();
    final repo = _FakeSettingsRepository(MetronomeSettings.defaults());
    final wakeLock = _FakeWakeLockService();

    final controller = MetronomeController(
      engine: engine,
      audioOutput: audio,
      settingsRepository: repo,
      wakeLockService: wakeLock,
    );

    await controller.initialize();
    await controller.start();
    await controller.stop();

    expect(controller.isRunning, false);
    expect(engine.started, false);
    expect(wakeLock.calls.last, false);
  });

  test('接收到节拍事件会更新状态并播放音效', () async {
    final engine = _FakeEngine();
    final audio = _FakeAudioOutput();
    final repo = _FakeSettingsRepository(MetronomeSettings.defaults());
    final wakeLock = _FakeWakeLockService();

    final controller = MetronomeController(
      engine: engine,
      audioOutput: audio,
      settingsRepository: repo,
      wakeLockService: wakeLock,
    );

    await controller.initialize();
    await controller.start();

    engine.emit(const BeatEvent(beatInBar: 1, isAccent: true));

    expect(controller.currentBeatInBar, 1);
    expect(controller.isAccentBeat, true);
    expect(controller.pulseCounter, 1);
    expect(audio.playCount, 1);
  });

  test('更新 BPM 时运行中会同步引擎', () async {
    final engine = _FakeEngine();
    final audio = _FakeAudioOutput();
    final repo = _FakeSettingsRepository(MetronomeSettings.defaults());
    final wakeLock = _FakeWakeLockService();

    final controller = MetronomeController(
      engine: engine,
      audioOutput: audio,
      settingsRepository: repo,
      wakeLockService: wakeLock,
    );

    await controller.initialize();
    await controller.start();
    await controller.updateBpm(140);

    expect(controller.settings.bpm, 140);
    expect(engine.setBpmCount, 1);
  });
}
