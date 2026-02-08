import 'package:wakelock_plus/wakelock_plus.dart';

import '../../domain/services/wake_lock_service.dart';

class WakelockPlusService implements WakeLockService {
  @override
  Future<void> setEnabled(bool enabled) {
    return WakelockPlus.toggle(enable: enabled);
  }
}
