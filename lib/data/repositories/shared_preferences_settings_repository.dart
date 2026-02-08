import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/metronome_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  static const String _bpmKey = 'settings_bpm';
  static const String _beatsPerBarKey = 'settings_beats_per_bar';
  static const String _soundKey = 'settings_sound';
  static const String _volumeKey = 'settings_volume';
  static const String _isMutedKey = 'settings_is_muted';
  static const String _keepAwakeKey = 'settings_keep_awake';

  @override
  Future<MetronomeSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = MetronomeSettings.defaults();

    final soundName = prefs.getString(_soundKey);
    final sound = SoundType.values.firstWhere(
      (value) => value.name == soundName,
      orElse: () => defaults.sound,
    );

    return defaults.copyWith(
      bpm: prefs.getInt(_bpmKey),
      beatsPerBar: prefs.getInt(_beatsPerBarKey),
      sound: sound,
      volume: prefs.getDouble(_volumeKey),
      isMuted: prefs.getBool(_isMutedKey),
      keepAwake: prefs.getBool(_keepAwakeKey),
    );
  }

  @override
  Future<void> save(MetronomeSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bpmKey, settings.bpm);
    await prefs.setInt(_beatsPerBarKey, settings.beatsPerBar);
    await prefs.setString(_soundKey, settings.sound.name);
    await prefs.setDouble(_volumeKey, settings.volume);
    await prefs.setBool(_isMutedKey, settings.isMuted);
    await prefs.setBool(_keepAwakeKey, settings.keepAwake);
  }
}
