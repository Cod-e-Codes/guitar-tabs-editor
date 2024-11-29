
# Guitar Tabs Editor

Guitar Tabs Editor is a Flutter application that allows you to create, edit, and play guitar tablatures. With features like MIDI playback, soundfont selection, and interactive editing, it is a perfect tool for guitar enthusiasts.

## Features

- Create and edit guitar tabs with an easy-to-use interface.
- Playback tabs using MIDI with customizable soundfonts.
- Highlight notes during playback for visual guidance.
- Save, share, and organize your guitar tabs.

## Requirements

- Flutter SDK
- Hive for local data storage
- flutter_midi_pro for MIDI playback
- Provider for state management

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Cod-e-Codes/guitar_tabs_editor.git
   cd guitar_tabs_editor
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## File Structure

- **lib/models**: Contains the `GuitarTab` model and Hive adapter.
- **lib/providers**: Manages the state and logic for tabs and playback.
- **lib/screens**: Includes the main screens for creating, editing, and managing tabs.
- **assets**: Holds soundfonts and other resources.

## Author

Developed by CodēCodes. For more projects, visit [CodēCodes GitHub](https://github.com/Cod-e-Codes).
