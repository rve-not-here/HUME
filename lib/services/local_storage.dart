// lib/services/local_storage.dart
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/mood_entry.dart';
import '../models/journal_entry.dart';

class LocalStorageService {
  static const String _moodBoxName = 'mood_entries';
  static const String _journalBoxName = 'journal_entries';
  static const String _settingsBoxName = 'app_settings';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    Hive.registerAdapter(MoodEntryAdapter());
    Hive.registerAdapter(JournalEntryAdapter());

    await Hive.openBox<MoodEntry>(_moodBoxName);
    await Hive.openBox<JournalEntry>(_journalBoxName);
    await Hive.openBox(_settingsBoxName);

    _isInitialized = true;
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    final box = Hive.box<MoodEntry>(_moodBoxName);
    await box.put(entry.id, entry);
  }

  Future<List<MoodEntry>> getMoodEntries() async {
    final box = Hive.box<MoodEntry>(_moodBoxName);
    return box.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> deleteMoodEntry(String id) async {
    final box = Hive.box<MoodEntry>(_moodBoxName);
    await box.delete(id);
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final box = Hive.box<JournalEntry>(_journalBoxName);
    await box.put(entry.id, entry);
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final box = Hive.box<JournalEntry>(_journalBoxName);
    return box.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> deleteJournalEntry(String id) async {
    final box = Hive.box<JournalEntry>(_journalBoxName);
    await box.delete(id);
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<String> exportData() async {
    final moodEntries = await getMoodEntries();
    final journalEntries = await getJournalEntries();

    final data = {
      'mood_entries': moodEntries.map((e) => e.toJson()).toList(),
      'journal_entries': journalEntries.map((e) => e.toJson()).toList(),
      'export_date': DateTime.now().toIso8601String(),
    };

    return jsonEncode(data);
  }

  Future<void> clearAllData() async {
    final moodBox = Hive.box<MoodEntry>(_moodBoxName);
    final journalBox = Hive.box<JournalEntry>(_journalBoxName);

    await moodBox.clear();
    await journalBox.clear();
  }

  Future<Map<String, dynamic>> getStorageStats() async {
    final moodBox = Hive.box<MoodEntry>(_moodBoxName);
    final journalBox = Hive.box<JournalEntry>(_journalBoxName);

    return {
      'mood_entries_count': moodBox.length,
      'journal_entries_count': journalBox.length,
      'total_entries': moodBox.length + journalBox.length,
    };
  }
}
