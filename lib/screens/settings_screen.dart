import 'package:flutter/material.dart';
import '../services/save_service.dart';
import '../services/sound_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.save});

  final SaveService save;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool sound;

  @override
  void initState() {
    super.initState();
    sound = widget.save.soundEnabled;
    SoundService.instance.setEnabled(sound);
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
            onChanged: (v) async {
              setState(() => sound = v);
              SoundService.instance.setEnabled(v);
              await widget.save.setSound(v);
            },
          ),

          const SizedBox(height: 20),
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
                SoundService.instance.setEnabled(true);
              });
            },
            child: const Text('RESET PROGRESS'),
          ),
        ],
      ),
    );
  }
}
