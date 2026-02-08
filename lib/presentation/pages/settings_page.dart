import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/metronome_constants.dart';
import '../../domain/entities/metronome_settings.dart';
import '../controllers/metronome_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MetronomeController>();
    final settings = controller.settings;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          const Text(
            '默认节拍',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2430),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsBpmControl(
            bpm: settings.bpm,
            onChanged: (value) {
              controller.updateBpm(value);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '音色与音量',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2430),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsSoundSelector(
            value: settings.sound,
            onChanged: (sound) {
              controller.updateSound(sound);
            },
          ),
          const SizedBox(height: 16),
          _SettingsVolumeControl(
            volume: settings.volume,
            onChanged: (value) {
              controller.updateVolume(value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('默认静音'),
            value: settings.isMuted,
            onChanged: (value) {
              controller.toggleMute(value);
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('阻止休眠'),
            subtitle: const Text('仅在播放时保持屏幕常亮'),
            value: settings.keepAwake,
            onChanged: (value) {
              controller.updateKeepAwake(value);
            },
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              controller.resetDefaults();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('恢复默认值'),
          ),
        ],
      ),
    );
  }
}

class _SettingsBpmControl extends StatelessWidget {
  final int bpm;
  final ValueChanged<int> onChanged;

  const _SettingsBpmControl({
    required this.bpm,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$bpm BPM',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: bpm.toDouble(),
          min: minBpm.toDouble(),
          max: maxBpm.toDouble(),
          divisions: maxBpm - minBpm,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

class _SettingsSoundSelector extends StatelessWidget {
  final SoundType value;
  final ValueChanged<SoundType> onChanged;

  const _SettingsSoundSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SoundType>(
          value: value,
          items: const [
            DropdownMenuItem(
              value: SoundType.click,
              child: Text('电子点击'),
            ),
            DropdownMenuItem(
              value: SoundType.wood,
              child: Text('木质敲击'),
            ),
          ],
          onChanged: (sound) {
            if (sound != null) {
              onChanged(sound);
            }
          },
        ),
      ),
    );
  }
}

class _SettingsVolumeControl extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _SettingsVolumeControl({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '音量 ${(volume * 100).round()}%',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7380),
          ),
        ),
        Slider(
          value: volume,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
