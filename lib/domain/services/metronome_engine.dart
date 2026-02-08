import '../entities/beat_event.dart';

abstract class MetronomeEngine {
  Stream<BeatEvent> get beatStream;
  bool get isRunning;

  void start({required int bpm, required int beatsPerBar});
  void setBpm(int bpm);
  void stop();
  void dispose();
}
