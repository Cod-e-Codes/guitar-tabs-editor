import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart'; // Use the new plugin
import 'package:hive/hive.dart';
import 'package:guitar_tabs_editor/models/guitar_tab.dart';

class TabProvider with ChangeNotifier {
  final MidiPro _midiPro = MidiPro(); // Initialize flutter_midi_pro
  late Box<GuitarTab> _tabBox;
  int? _soundfontId;
  int? _currentPlayingTabIndex; // To track the currently playing tab index
  bool _isPlaying = false; // Track if a tab is currently playing
  String _currentSoundfont = 'assets/guitar.sf2'; // Default soundfont path
  bool get isPlaying => _isPlaying;

  // To track currently playing notes as a list of string and position combinations
  final List<Map<String, int>> _currentPlayingNotes = [];

  // Define MIDI note for each string when played open
  final Map<int, int> _stringToMidiNote = {
    0: 64, // E (1st string, highest)
    1: 59, // B (2nd string)
    2: 55, // G (3rd string)
    3: 50, // D (4th string)
    4: 45, // A (5th string)
    5: 40, // E (6th string, lowest)
  };

  TabProvider() {
    _initializeHive();
    _initializeMidi(_currentSoundfont);
  }

  Future<void> _initializeHive() async {
    _tabBox = Hive.box<GuitarTab>('tabs');
  }

  Future<void> _initializeMidi(String soundfontPath) async {
    _soundfontId = await _midiPro.loadSoundfont(path: soundfontPath, bank: 0, program: 0);
  }

  List<GuitarTab> get tabs => _tabBox.values.toList();
  int? get currentPlayingTabIndex => _currentPlayingTabIndex;
  List<Map<String, int>> get currentPlayingNotes => _currentPlayingNotes;
  String get currentSoundfont => _currentSoundfont;

  void addTab(String name, String content) {
    final newTab = GuitarTab(name: name, content: content);
    _tabBox.add(newTab);
    notifyListeners();
  }

  void editTab(int index, String newName, String newContent) {
    if (index >= 0 && index < _tabBox.length) {
      final existingTab = _tabBox.getAt(index);
      if (existingTab != null) {
        final updatedTab = GuitarTab(name: newName, content: newContent);
        _tabBox.putAt(index, updatedTab);
        notifyListeners();
      }
    }
  }

  void removeTab(int index) {
    if (index >= 0 && index < _tabBox.length) {
      _tabBox.deleteAt(index);
      notifyListeners();
    }
  }

  Future<void> playTab(int tabIndex, String content) async {
    if (_soundfontId == null || _isPlaying) return;

    _currentPlayingTabIndex = tabIndex;
    _isPlaying = true;
    notifyListeners();

    final lines = content.split('\n');
    int maxLength = lines.map((line) => line.length).reduce((a, b) => a > b ? a : b);

    for (int pos = 0; pos < maxLength; pos++) {
      if (!_isPlaying) break;

      _currentPlayingNotes.clear();
      notifyListeners();

      List<int> notesToPlay = [];
      for (int stringIndex = 0; stringIndex < 6; stringIndex++) {
        final line = lines[stringIndex];
        if (pos < line.length && line[pos] != '-' && line[pos] != '|') {
          final fret = int.tryParse(line[pos]);
          if (fret != null) {
            final midiNote = _stringToMidiNote[stringIndex]! + fret;
            notesToPlay.add(midiNote);

            _currentPlayingNotes.add({
              "stringIndex": stringIndex,
              "position": pos,
            });
            notifyListeners();
          }
        }
      }

      for (var midiNote in notesToPlay) {
        _midiPro.playNote(
          sfId: _soundfontId!,
          channel: 0,
          key: midiNote,
          velocity: 127,
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));
      for (var midiNote in notesToPlay) {
        _midiPro.stopNote(
          sfId: _soundfontId!,
          channel: 0,
          key: midiNote,
        );
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }

    stopTab();
  }

  void stopTab() {
    _isPlaying = false;
    _currentPlayingNotes.clear();
    _currentPlayingTabIndex = null;
    notifyListeners();
  }

  // Function to change soundfont
  Future<void> changeSoundfont(String newSoundfont) async {
    _currentSoundfont = newSoundfont;
    await _initializeMidi(_currentSoundfont);
    notifyListeners();
  }
}
