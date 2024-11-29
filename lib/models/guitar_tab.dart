import 'package:hive/hive.dart';

part 'guitar_tab.g.dart'; // Update this with the correct file name

@HiveType(typeId: 0) // Unique typeId for Hive
class GuitarTab {
  @HiveField(0)
  String name;

  @HiveField(1)
  String content;

  GuitarTab({required this.name, required this.content});
}
