import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';
import 'package:rythemtick/domain/repositories/settings_repository.dart';
import 'package:rythemtick/domain/services/audio_output.dart';
import 'package:rythemtick/domain/services/metronome_engine.dart';
import 'package:rythemtick/domain/services/wake_lock_service.dart';
import 'package:rythemtick/presentation/controllers/metronome_controller.dart';
import 'package:rythemtick/presentation/pages/metronome_page.dart';
import 'package:rythemtick/domain/entities/beat_event.dart';

class _StubSettingsRepository implements SettingsRepository {
  @override
  Future<MetronomeSettings> load() async => MetronomeSettings.defaults();

  @override
  Future<void> save(MetronomeSettings settings) async {}
}

class _StubAudioOutput implements AudioOutput {
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

class _StubEngine implements MetronomeEngine {
  @override
  Stream<BeatEvent> get beatStream => const Stream.empty();

  @override
  bool get isRunning => false;

  @override
  void dispose() {}

  @override
  void setBpm(int bpm) {}

  @override
  void start({required int bpm, required int beatsPerBar}) {}

  @override
  void stop() {}
}

class _StubWakeLockService implements WakeLockService {
  @override
  Future<void> setEnabled(bool enabled) async {}
}

void main() {
  testWidgets('主页展示 BPM 与开始按钮', (tester) async {
    final controller = MetronomeController(
      engine: _StubEngine(),
      audioOutput: _StubAudioOutput(),
      settingsRepository: _StubSettingsRepository(),
      wakeLockService: _StubWakeLockService(),
    );

    await controller.initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(
          home: MetronomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('120 BPM'), findsOneWidget);
    expect(find.text('开始'), findsOneWidget);
    expect(find.text('强拍'), findsOneWidget);
    expect(find.byKey(const Key('beat-dot-1')), findsOneWidget);
    expect(find.byKey(const Key('beat-dot-2')), findsOneWidget);
    expect(find.byKey(const Key('beat-dot-3')), findsOneWidget);
    expect(find.byKey(const Key('beat-dot-4')), findsOneWidget);
  });
}
