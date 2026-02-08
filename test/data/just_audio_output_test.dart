import 'package:flutter_test/flutter_test.dart';
import 'package:rythemtick/data/audio/just_audio_output.dart';
import 'package:rythemtick/data/audio/audio_player_port.dart';
import 'package:rythemtick/domain/entities/metronome_settings.dart';

class _FakeAudioPlayerPort implements AudioPlayerPort {
  final List<String> assets = [];
  int playCount = 0;
  double? lastVolume;
  Duration? lastSeek;

  @override
  Future<void> dispose() async {}

  @override
  Future<void> play() async {
    playCount += 1;
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration position) async {
    lastSeek = position;
  }

  @override
  Future<void> setAsset(String assetPath) async {
    assets.add(assetPath);
  }

  @override
  Future<void> setVolume(double volume) async {
    lastVolume = volume;
  }
}

void main() {
  test('loadSounds 会加载两种音色资源', () async {
    final click = _FakeAudioPlayerPort();
    final wood = _FakeAudioPlayerPort();
    final output = JustAudioOutput(clickPlayer: click, woodPlayer: wood);

    await output.loadSounds();

    expect(click.assets, [JustAudioOutput.clickAsset]);
    expect(wood.assets, [JustAudioOutput.woodAsset]);
  });

  test('playBeat 根据音色选择播放器并设置音量', () async {
    final click = _FakeAudioPlayerPort();
    final wood = _FakeAudioPlayerPort();
    final output = JustAudioOutput(clickPlayer: click, woodPlayer: wood);

    await output.loadSounds();
    await output.playBeat(
      isAccent: true,
      sound: SoundType.click,
      volume: 0.5,
      isMuted: false,
    );

    expect(click.playCount, 1);
    expect(wood.playCount, 0);
    expect(click.lastSeek, Duration.zero);
    expect(click.lastVolume, closeTo(0.6, 0.001));
  });

  test('静音时不播放声音', () async {
    final click = _FakeAudioPlayerPort();
    final wood = _FakeAudioPlayerPort();
    final output = JustAudioOutput(clickPlayer: click, woodPlayer: wood);

    await output.loadSounds();
    await output.playBeat(
      isAccent: false,
      sound: SoundType.wood,
      volume: 0.8,
      isMuted: true,
    );

    expect(click.playCount, 0);
    expect(wood.playCount, 0);
  });
}
