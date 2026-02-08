import '../entities/metronome_settings.dart';

abstract class SettingsRepository {
  Future<MetronomeSettings> load();
  Future<void> save(MetronomeSettings settings);
}
