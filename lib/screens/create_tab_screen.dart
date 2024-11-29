import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:guitar_tabs_editor/providers/tab_provider.dart';

class CreateTabScreen extends StatefulWidget {
  const CreateTabScreen({super.key});

  @override
  CreateTabScreenState createState() => CreateTabScreenState();
}

class CreateTabScreenState extends State<CreateTabScreen> {
  final int _numStrings = 6; // Standard guitar strings (EADGBE)
  final int _tabLength = 17; // Length of the tab line for each string
  final TextEditingController _nameController = TextEditingController();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    // Initialize controllers for each string with empty tab content
    _controllers = List.generate(
      _numStrings,
          (index) => TextEditingController(text: '-' * _tabLength),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Tab'),
        backgroundColor: Colors.brown[600], // Represent the guitar neck
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown, Colors.orangeAccent], // Guitar wood gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tab Name',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTabEditor(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent, // Guitar-like feel
              ),
              onPressed: _saveTab,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTab() {
    final newTabContent =
    _controllers.map((controller) => controller.text).join('\n');
    Provider.of<TabProvider>(context, listen: false)
        .addTab(_nameController.text, newTabContent);
    Navigator.pop(context);
  }

  Widget _buildTabEditor() {
    return Column(
      children: List.generate(_numStrings, (index) {
        return Row(
          children: [
            Text(
              '${_getStringLabel(index)}|',
              style: const TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
            ),
            Expanded(
              child: TextField(
                controller: _controllers[index],
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_tabLength),
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\-]')), // Allow digits and '-'
                ],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
              ),
            ),
            const Text(
              '|',
              style: TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
            ),
          ],
        );
      }),
    );
  }

  String _getStringLabel(int index) {
    switch (index) {
      case 0:
        return 'e';
      case 1:
        return 'B';
      case 2:
        return 'G';
      case 3:
        return 'D';
      case 4:
        return 'A';
      case 5:
        return 'E';
      default:
        return '';
    }
  }
}
