import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/save_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.save});

  final SaveService save;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool sound;
  late bool vibration;
  late int backgroundTheme;

  @override
  void initState() {
    super.initState();
    sound = widget.save.soundEnabled;
    vibration = widget.save.vibrationEnabled;
    backgroundTheme = widget.save.backgroundTheme.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SwitchListTile(
            value: sound,
            title: const Text('Sound'),
            subtitle: const Text('Ball hits & brick breaks'),
            onChanged: (v) async {
              setState(() => sound = v);
              await widget.save.setSound(v);
            },
          ),
          SwitchListTile(
            value: vibration,
            title: const Text('Vibration'),
            onChanged: (v) async {
              setState(() => vibration = v);
              await widget.save.setVibration(v);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'BACKGROUND',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: List.generate(BackgroundThemes.names.length, (i) {
              final selected = backgroundTheme == i;
              final swatch = BackgroundThemes.swatch[i];

              return GestureDetector(
                onTap: () async {
                  setState(() => backgroundTheme = i);
                  await widget.save.setBackgroundTheme(i);
                },
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: BackgroundThemes.gradients[i],
                        ),
                        border: Border.all(
                          color: selected ? swatch : Colors.white24,
                          width: selected ? 3 : 1,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: swatch.withValues(alpha: .55),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 22,
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 68,
                      child: Text(
                        BackgroundThemes.names[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Best Score'),
            trailing: Text('${widget.save.highScore}'),
          ),
          ListTile(
            title: const Text('Best Level'),
            trailing: Text('${widget.save.bestLevel}'),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () async {
              await widget.save.reset();

              setState(() {
                sound = true;
                vibration = true;
                backgroundTheme = 0;
              });
            },
            child: const Text('RESET PROGRESS'),
          ),
        ],
      ),
    );
  }
}
