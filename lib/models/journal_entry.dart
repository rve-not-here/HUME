import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 1)
class JournalEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime dateTime;

  @HiveField(4)
  final String? mood;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    this.mood,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
      'mood': mood,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      dateTime: DateTime.parse(json['dateTime']),
      mood: json['mood'],
    );
  }
}
