import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guitar_tabs_editor/providers/tab_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    // List of available soundfonts
    final soundfonts = [
      {'name': 'Guitar', 'path': 'assets/guitar.sf2'},
      {'name': 'Bass', 'path': 'assets/bass.sf2'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.brown[600],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select Soundfont',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: soundfonts.length,
                itemBuilder: (context, index) {
                  final soundfont = soundfonts[index];
                  return ListTile(
                    title: Text(soundfont['name']!),
                    trailing: tabProvider.currentSoundfont == soundfont['path']
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      tabProvider.changeSoundfont(soundfont['path']!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${soundfont['name']} soundfont selected!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
