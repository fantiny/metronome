import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/metronome_constants.dart';
import '../../domain/entities/metronome_settings.dart';
import '../controllers/metronome_controller.dart';
import '../widgets/beat_indicator.dart';
import '../widgets/pulse_indicator.dart';
import 'settings_page.dart';

class MetronomePage extends StatelessWidget {
  const MetronomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MetronomeController>();
    final settings = controller.settings;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('节拍器'),
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            Center(
              child: PulseIndicator(
                pulseTick: controller.pulseCounter,
                isAccent: controller.isAccentBeat,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${settings.bpm} BPM',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2430),
                ),
              ),
            ),
            const SizedBox(height: 8),
            BeatIndicatorRow(
              currentBeat: controller.currentBeatInBar,
              beatsPerBar: settings.beatsPerBar,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                controller.isRunning
                    ? '第 ${controller.currentBeatInBar} 拍'
                    : '准备中',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7380),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _BpmControlRow(
              bpm: settings.bpm,
              onChanged: (value) {
                controller.updateBpm(value);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () {
                  controller.toggleRunning();
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  controller.isRunning ? '停止' : '开始',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '声音',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2430),
              ),
            ),
            const SizedBox(height: 8),
            _SoundSelector(
              value: settings.sound,
              onChanged: (sound) {
                controller.updateSound(sound);
              },
            ),
            const SizedBox(height: 16),
            _VolumeControl(
              volume: settings.volume,
              onChanged: (value) {
                controller.updateVolume(value);
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('静音'),
              value: settings.isMuted,
              onChanged: (value) {
                controller.toggleMute(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BpmControlRow extends StatelessWidget {
  final int bpm;
  final ValueChanged<int> onChanged;

  const _BpmControlRow({
    required this.bpm,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: bpm.toDouble(),
          min: minBpm.toDouble(),
          max: maxBpm.toDouble(),
          divisions: maxBpm - minBpm,
          label: bpm.toString(),
          onChanged: (value) => onChanged(value.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => onChanged(bpm - 1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '范围 $minBpm-$maxBpm',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7380),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(bpm + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

class _SoundSelector extends StatelessWidget {
  final SoundType value;
  final ValueChanged<SoundType> onChanged;

  const _SoundSelector({
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

class _VolumeControl extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeControl({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '音量',
          style: TextStyle(
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
