import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String mood;

  @HiveField(2)
  final int intensity;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final DateTime dateTime;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.intensity,
    this.note,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'intensity': intensity,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      mood: json['mood'],
      intensity: json['intensity'],
      note: json['note'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
