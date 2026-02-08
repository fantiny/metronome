enum SoundType {
  click,
  wood,
}

class MetronomeSettings {
  final int bpm;
  final int beatsPerBar;
  final SoundType sound;
  final double volume;
  final bool isMuted;
  final bool keepAwake;

  const MetronomeSettings({
    required this.bpm,
    required this.beatsPerBar,
    required this.sound,
    required this.volume,
    required this.isMuted,
    required this.keepAwake,
  });

  factory MetronomeSettings.defaults() {
    return const MetronomeSettings(
      bpm: 120,
      beatsPerBar: 4,
      sound: SoundType.click,
      volume: 1.0,
      isMuted: false,
      keepAwake: true,
    );
  }

  MetronomeSettings copyWith({
    int? bpm,
    int? beatsPerBar,
    SoundType? sound,
    double? volume,
    bool? isMuted,
    bool? keepAwake,
  }) {
    return MetronomeSettings(
      bpm: bpm ?? this.bpm,
      beatsPerBar: beatsPerBar ?? this.beatsPerBar,
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      keepAwake: keepAwake ?? this.keepAwake,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MetronomeSettings &&
        other.bpm == bpm &&
        other.beatsPerBar == beatsPerBar &&
        other.sound == sound &&
        other.volume == volume &&
        other.isMuted == isMuted &&
        other.keepAwake == keepAwake;
  }

  @override
  int get hashCode => Object.hash(
        bpm,
        beatsPerBar,
        sound,
        volume,
        isMuted,
        keepAwake,
      );
}
