import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rythemtick/data/engines/scheduled_metronome_engine.dart';
import 'package:rythemtick/domain/entities/beat_event.dart';

void main() {
  test('开始后立即发出首拍，随后按间隔输出拍子', () {
    fakeAsync((async) {
      final engine = ScheduledMetronomeEngine();
      final beats = <BeatEvent>[];

      engine.beatStream.listen(beats.add);

      engine.start(bpm: 60, beatsPerBar: 4);

      expect(beats.length, 1);
      expect(beats.first.isAccent, true);
      expect(beats.first.beatInBar, 1);

      async.elapse(const Duration(seconds: 1));

      expect(beats.length, 2);
      expect(beats[1].beatInBar, 2);
      expect(beats[1].isAccent, false);

      engine.stop();
      async.elapse(const Duration(seconds: 2));

      expect(beats.length, 2);
    });
  });
}
