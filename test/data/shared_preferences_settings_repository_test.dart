import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rythemtick/data/repositories/shared_preferences_settings_repository.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('无本地数据时返回默认设置', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = SharedPreferencesSettingsRepository();

    final settings = await repo.load();

    expect(settings, MetronomeSettings.defaults());
  });

  test('保存后可完整读取设置', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = SharedPreferencesSettingsRepository();
    final custom = MetronomeSettings.defaults().copyWith(
      bpm: 96,
      beatsPerBar: 4,
      sound: SoundType.wood,
      volume: 0.7,
      isMuted: true,
      keepAwake: false,
    );

    await repo.save(custom);
    final loaded = await repo.load();

    expect(loaded, custom);
  });
}
