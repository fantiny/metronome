import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/audio/just_audio_output.dart';
import 'data/engines/scheduled_metronome_engine.dart';
import 'data/repositories/shared_preferences_settings_repository.dart';
import 'data/services/wakelock_plus_service.dart';
import 'presentation/controllers/metronome_controller.dart';
import 'presentation/pages/metronome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = MetronomeController(
    engine: ScheduledMetronomeEngine(),
    audioOutput: JustAudioOutput(),
    settingsRepository: SharedPreferencesSettingsRepository(),
    wakeLockService: WakelockPlusService(),
  );
  runApp(MetronomeApp(controller: controller));
}

class MetronomeApp extends StatefulWidget {
  final MetronomeController controller;

  const MetronomeApp({super.key, required this.controller});

  @override
  State<MetronomeApp> createState() => _MetronomeAppState();
}

class _MetronomeAppState extends State<MetronomeApp> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.controller.initialize());
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F7DFF),
      background: const Color(0xFFF6F7FB),
    );

    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: MaterialApp(
        title: '节拍器',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        ),
        home: const MetronomePage(),
      ),
    );
  }
}
