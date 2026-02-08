import 'dart:async';
import 'dart:math';

import '../../domain/entities/beat_event.dart';
import '../../domain/services/metronome_engine.dart';

class ScheduledMetronomeEngine implements MetronomeEngine {
  final StreamController<BeatEvent> _controller =
      StreamController<BeatEvent>.broadcast(sync: true);
  Timer? _timer;
  bool _isRunning = false;
  int _bpm = 120;
  int _beatsPerBar = 4;
  int _beatInBar = 0;

  @override
  Stream<BeatEvent> get beatStream => _controller.stream;

  @override
  bool get isRunning => _isRunning;

  @override
  void start({required int bpm, required int beatsPerBar}) {
    _bpm = max(1, bpm);
    _beatsPerBar = max(1, beatsPerBar);
    _beatInBar = 0;
    _isRunning = true;

    _emitBeat();
    _scheduleNext();
  }

  @override
  void setBpm(int bpm) {
    _bpm = max(1, bpm);
    if (_isRunning) {
      _timer?.cancel();
      _scheduleNext();
    }
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  @override
  void dispose() {
    stop();
    _controller.close();
  }

  void _scheduleNext() {
    final interval = Duration(milliseconds: (60000 / _bpm).round());
    _timer = Timer(interval, () {
      if (!_isRunning) {
        return;
      }
      _emitBeat();
      _scheduleNext();
    });
  }

  void _emitBeat() {
    _beatInBar = (_beatInBar % _beatsPerBar) + 1;
    _controller.add(BeatEvent(
      beatInBar: _beatInBar,
      isAccent: _beatInBar == 1,
    ));
  }
}
