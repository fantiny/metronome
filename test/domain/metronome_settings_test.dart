import 'package:flutter_test/flutter_test.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';

void main() {
  test('默认设置符合需求', () {
    final settings = MetronomeSettings.defaults();

    expect(settings.bpm, 120);
    expect(settings.beatsPerBar, 4);
    expect(settings.sound, SoundType.click);
    expect(settings.volume, 1.0);
    expect(settings.isMuted, false);
    expect(settings.keepAwake, true);
  });

  test('copyWith 只修改指定字段', () {
    final base = MetronomeSettings.defaults();

    final updated = base.copyWith(bpm: 80, isMuted: true, volume: 0.6);

    expect(updated.bpm, 80);
    expect(updated.isMuted, true);
    expect(updated.volume, 0.6);
    expect(updated.beatsPerBar, base.beatsPerBar);
    expect(updated.sound, base.sound);
    expect(updated.keepAwake, base.keepAwake);
  });
}
