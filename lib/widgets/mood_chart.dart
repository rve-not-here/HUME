import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../theme/colors.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  const MoodChart({Key? key, required this.moodEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: moodEntries.length,
      itemBuilder: (context, index) {
        final entry = moodEntries[index];
        return _buildMoodBar(entry, context);
      },
    );
  }

  Widget _buildMoodBar(MoodEntry entry, BuildContext context) {
    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${entry.intensity}',
            style: TextStyle(fontSize: 12),
          ),
          Container(
            height: entry.intensity * 20.0,
            width: 30,
            decoration: BoxDecoration(
              color: _getMoodColor(entry.mood),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Text(
            _getDayAbbreviation(entry.dateTime),
            style: TextStyle(fontSize: 12),
          ),
          Text(
            _getMoodEmoji(entry.mood),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(String mood) {
    final colors = {
      'Happy': AppColors.happy,
      'Calm': AppColors.calm,
      'Sad': AppColors.sad,
      'Anxious': AppColors.anxious,
      'Angry': AppColors.angry,
    };
    return colors[mood] ?? Colors.grey;
  }

  String _getMoodEmoji(String mood) {
    final emojis = {
      'Happy': '😊',
      'Calm': '😌',
      'Sad': '😢',
      'Anxious': '😰',
      'Angry': '😠',
    };
    return emojis[mood] ?? '';
  }

  String _getDayAbbreviation(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
  }
}
