import 'package:flutter_test/flutter_test.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';
import 'package:rythemtick/data/services/wakelock_plus_service.dart';

class _FakeWakelockPlatform extends WakelockPlusPlatformInterface {
  bool? lastEnable;
  bool enabledValue = false;

  @override
  Future<void> toggle({required bool enable}) async {
    lastEnable = enable;
    enabledValue = enable;
  }

  @override
  Future<bool> get enabled async => enabledValue;
}

void main() {
  test('setEnabled 调用 wakelock_plus toggle', () async {
    final previous = wakelockPlusPlatformInstance;
    final fake = _FakeWakelockPlatform();
    wakelockPlusPlatformInstance = fake;

    final service = WakelockPlusService();

    await service.setEnabled(true);
    expect(fake.lastEnable, true);

    await service.setEnabled(false);
    expect(fake.lastEnable, false);

    wakelockPlusPlatformInstance = previous;
  });
}
