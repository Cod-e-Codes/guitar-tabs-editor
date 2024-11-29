import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:guitar_tabs_editor/providers/tab_provider.dart';
import 'package:guitar_tabs_editor/models/guitar_tab.dart'; // Import your model
import 'package:guitar_tabs_editor/screens/home_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(GuitarTabAdapter()); // Use the correct adapter name

  // Open a Hive box
  await Hive.openBox<GuitarTab>('tabs'); // Open box for GuitarTab

  runApp(const GuitarTabsEditorApp());
}

class GuitarTabsEditorApp extends StatelessWidget {
  const GuitarTabsEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: MaterialApp(
        title: 'Guitar Tabs Editor',
        theme: ThemeData(
          primarySwatch: Colors.orange, // A warm color to represent a guitar's wood
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Courier', fontSize: 14), // Replaces bodyText2
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
