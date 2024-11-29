import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:guitar_tabs_editor/providers/tab_provider.dart';
import 'package:guitar_tabs_editor/screens/edit_tab_screen.dart';
import 'package:guitar_tabs_editor/screens/create_tab_screen.dart';
import 'package:guitar_tabs_editor/screens/settings_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guitar Tabs Editor'),
        backgroundColor: Colors.brown[600], // Represent the guitar neck
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown, Colors.orangeAccent], // Guitar wood gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<TabProvider>(
          builder: (context, tabProvider, _) {
            return ListView.builder(
              itemCount: tabProvider.tabs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.brown[300], // Soft brown for a guitar body feel
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      tabProvider.tabs[index].name,
                      style: const TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
                    ),
                    subtitle: _buildHighlightedTab(
                      context,
                      tabProvider,
                      tabProvider.tabs[index].content,
                      index, // Pass the tab index
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.yellow[800], // Accent color for icons
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTabScreen(index: index),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent, // Red to represent action
                          onPressed: () {
                            tabProvider.removeTab(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          color: Colors.greenAccent, // Bright green for sharing
                          onPressed: () {
                            final tab = tabProvider.tabs[index];
                            Share.share(
                              'Check out my guitar tab:\n\n${tab.name}\n\n${tab.content}',
                            );
                          },
                        ),
                        IconButton(
                          icon: tabProvider.isPlaying && tabProvider.currentPlayingTabIndex == index
                              ? const Icon(Icons.stop)
                              : const Icon(Icons.play_arrow),
                          color: Colors.blueAccent, // Play/Stop icons stand out in blue
                          onPressed: () {
                            if (tabProvider.isPlaying && tabProvider.currentPlayingTabIndex == index) {
                              tabProvider.stopTab();
                            } else {
                              tabProvider.playTab(index, tabProvider.tabs[index].content);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTabScreen(),
            ),
          );
        },
        backgroundColor: Colors.orangeAccent, // Vibrant orange for the FAB
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHighlightedTab(BuildContext context, TabProvider tabProvider, String content, int tabIndex) {
    final lines = content.split('\n');
    const stringColors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(6, (stringIndex) {
        return Row(
          children: List.generate(lines[stringIndex].length, (pos) {
            // Check if the current note should be highlighted
            bool isHighlighted = (tabProvider.currentPlayingTabIndex == tabIndex) &&
                tabProvider.currentPlayingNotes.any((note) =>
                note["stringIndex"] == stringIndex &&
                    note["position"] == pos);
            return Text(
              lines[stringIndex][pos],
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
                backgroundColor: isHighlighted ? Colors.yellow : Colors.transparent,
                color: stringColors[stringIndex], // Each string gets its own color
              ),
            );
          }),
        );
      }),
    );
  }
}
