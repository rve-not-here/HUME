import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import '../models/journal_entry.dart';
import 'local_storage.dart';

class MoodService with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  List<MoodEntry> _moodEntries = [];
  List<JournalEntry> _journalEntries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MoodEntry> get moodEntries => _moodEntries;
  List<JournalEntry> get journalEntries => _journalEntries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _storage.init();
      await _loadAllData();
    } catch (e) {
      _errorMessage = 'Failed to load data. Please restart the app.';
      debugPrint('Error initializing MoodService: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAllData() async {
    _moodEntries = await _storage.getMoodEntries();
    _journalEntries = await _storage.getJournalEntries();
    notifyListeners();
  }

  Future<void> addMood({
    required String mood,
    required int intensity,
    String? note,
  }) async {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood,
      intensity: intensity.clamp(1, 5), // Validate intensity
      note: note,
      dateTime: DateTime.now(),
    );

    _moodEntries.insert(0, entry);
    await _storage.saveMoodEntry(entry);
    notifyListeners();
  }

  Future<void> addJournalEntry({
    required String title,
    required String content,
    String? mood,
  }) async {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      dateTime: DateTime.now(),
      mood: mood,
    );

    _journalEntries.insert(0, entry);
    await _storage.saveJournalEntry(entry);
    notifyListeners();
  }

  Future<void> deleteMoodEntry(String id) async {
    _moodEntries.removeWhere((entry) => entry.id == id);
    await _storage.deleteMoodEntry(id);
    notifyListeners();
  }

  Future<void> deleteJournalEntry(String id) async {
    _journalEntries.removeWhere((entry) => entry.id == id);
    await _storage.deleteJournalEntry(id);
    notifyListeners();
  }

  List<MoodEntry> getRecentMoods() {
    return _moodEntries.take(7).toList();
  }

  List<MoodEntry> getMoodsForDate(DateTime date) {
    return _moodEntries
        .where((entry) =>
            entry.dateTime.year == date.year &&
            entry.dateTime.month == date.month &&
            entry.dateTime.day == date.day)
        .toList();
  }

  Map<String, dynamic> getMoodAnalytics() {
    if (_moodEntries.isEmpty) {
      return {
        'totalEntries': 0,
        'moodDistribution': <String, int>{},
        'weeklyTrends': <String, int>{},
        'averageIntensities': <String, double>{},
        'averageIntensityOverall': 0.0,
      };
    }

    final moodCounts = <String, int>{};
    final weeklyMoods = <String, int>{};
    final intensitySum = <String, double>{};
    final intensityCount = <String, int>{};

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    for (var entry in _moodEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;

      if (entry.dateTime.isAfter(oneWeekAgo)) {
        weeklyMoods[entry.mood] = (weeklyMoods[entry.mood] ?? 0) + 1;
      }

      intensitySum[entry.mood] =
          (intensitySum[entry.mood] ?? 0.0) + entry.intensity;
      intensityCount[entry.mood] = (intensityCount[entry.mood] ?? 0) + 1;
    }

    final averageIntensities = <String, double>{};
    intensitySum.forEach((mood, sum) {
      averageIntensities[mood] = sum / (intensityCount[mood] ?? 1);
    });

    // FIXED: Safe division by zero
    final avgIntensityOverall = _moodEntries.isEmpty
        ? 0.0
        : _moodEntries.map((e) => e.intensity).reduce((a, b) => a + b) /
            _moodEntries.length;

    return {
      'totalEntries': _moodEntries.length,
      'moodDistribution': moodCounts,
      'weeklyTrends': weeklyMoods,
      'averageIntensities': averageIntensities,
      'averageIntensityOverall': avgIntensityOverall,
    };
  }

  Future<Map<String, dynamic>> getStorageStatistics() async {
    return await _storage.getStorageStats();
  }

  Future<String> exportUserData() async {
    return await _storage.exportData();
  }

  Future<void> clearAllData() async {
    await _storage.clearAllData();
    _moodEntries.clear();
    _journalEntries.clear();
    notifyListeners();
  }
}
