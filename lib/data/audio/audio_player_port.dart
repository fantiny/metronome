abstract class AudioPlayerPort {
  Future<void> setAsset(String assetPath);
  Future<void> seek(Duration position);
  Future<void> play();
  Future<void> pause();
  Future<void> setVolume(double volume);
  Future<void> dispose();
}
