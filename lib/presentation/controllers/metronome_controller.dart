import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/metronome_constants.dart';
import '../../domain/entities/beat_event.dart';
import '../../domain/entities/metronome_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/audio_output.dart';
import '../../domain/services/metronome_engine.dart';
import '../../domain/services/wake_lock_service.dart';

class MetronomeController extends ChangeNotifier {
  final MetronomeEngine _engine;
  final AudioOutput _audioOutput;
  final SettingsRepository _settingsRepository;
  final WakeLockService _wakeLockService;

  StreamSubscription<BeatEvent>? _beatSubscription;
  MetronomeSettings _settings = MetronomeSettings.defaults();
  bool _isRunning = false;
  int _currentBeatInBar = 0;
  bool _isAccentBeat = false;
  int _pulseCounter = 0;

  MetronomeController({
    required MetronomeEngine engine,
    required AudioOutput audioOutput,
    required SettingsRepository settingsRepository,
    required WakeLockService wakeLockService,
  })  : _engine = engine,
        _audioOutput = audioOutput,
        _settingsRepository = settingsRepository,
        _wakeLockService = wakeLockService;

  MetronomeSettings get settings => _settings;
  bool get isRunning => _isRunning;
  int get currentBeatInBar => _currentBeatInBar;
  bool get isAccentBeat => _isAccentBeat;
  int get pulseCounter => _pulseCounter;

  Future<void> initialize() async {
    _settings = await _settingsRepository.load();
    await _audioOutput.loadSounds();
    notifyListeners();
  }

  Future<void> start() async {
    if (_isRunning) {
      return;
    }
    _isRunning = true;
    _ensureBeatSubscription();
    _engine.start(
      bpm: _settings.bpm,
      beatsPerBar: _settings.beatsPerBar,
    );
    await _applyWakeLock();
    notifyListeners();
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }
    _engine.stop();
    _isRunning = false;
    await _applyWakeLock();
    notifyListeners();
  }

  Future<void> toggleRunning() async {
    if (_isRunning) {
      await stop();
    } else {
      await start();
    }
  }

  Future<void> updateBpm(int bpm) async {
    final clamped = _clampBpm(bpm);
    if (clamped == _settings.bpm) {
      return;
    }
    _settings = _settings.copyWith(bpm: clamped);
    await _settingsRepository.save(_settings);
    if (_isRunning) {
      _engine.setBpm(clamped);
    }
    notifyListeners();
  }

  Future<void> updateVolume(double volume) async {
    final clamped = _clampVolume(volume);
    if (clamped == _settings.volume) {
      return;
    }
    _settings = _settings.copyWith(volume: clamped);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  Future<void> toggleMute(bool isMuted) async {
    if (isMuted == _settings.isMuted) {
      return;
    }
    _settings = _settings.copyWith(isMuted: isMuted);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  Future<void> updateSound(SoundType sound) async {
    if (sound == _settings.sound) {
      return;
    }
    _settings = _settings.copyWith(sound: sound);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  Future<void> updateKeepAwake(bool keepAwake) async {
    if (keepAwake == _settings.keepAwake) {
      return;
    }
    _settings = _settings.copyWith(keepAwake: keepAwake);
    await _settingsRepository.save(_settings);
    await _applyWakeLock();
    notifyListeners();
  }

  Future<void> resetDefaults() async {
    _settings = MetronomeSettings.defaults();
    await _settingsRepository.save(_settings);
    if (_isRunning) {
      _engine.setBpm(_settings.bpm);
    }
    await _applyWakeLock();
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_applyWakeLock(forceDisable: true));
    _beatSubscription?.cancel();
    _engine.dispose();
    _audioOutput.dispose();
    super.dispose();
  }

  void _ensureBeatSubscription() {
    _beatSubscription ??= _engine.beatStream.listen(_handleBeat);
  }

  void _handleBeat(BeatEvent event) {
    _currentBeatInBar = event.beatInBar;
    _isAccentBeat = event.isAccent;
    _pulseCounter += 1;
    unawaited(_audioOutput.playBeat(
      isAccent: event.isAccent,
      sound: _settings.sound,
      volume: _settings.volume,
      isMuted: _settings.isMuted,
    ));
    notifyListeners();
  }

  Future<void> _applyWakeLock({bool forceDisable = false}) async {
    final shouldEnable = _isRunning && _settings.keepAwake && !forceDisable;
    await _wakeLockService.setEnabled(shouldEnable);
  }

  int _clampBpm(int bpm) {
    final clamped = bpm.clamp(minBpm, maxBpm);
    return clamped is int ? clamped : clamped.round();
  }

  double _clampVolume(double volume) {
    final clamped = volume.clamp(0.0, 1.0);
    return clamped is double ? clamped : clamped.toDouble();
  }
}
