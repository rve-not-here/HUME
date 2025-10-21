import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../services/mood_service.dart';
import '../models/mood_entry.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_chart.dart';
import '../theme/colors.dart';

class MoodTrackingScreen extends StatelessWidget {
  const MoodTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mood Tracking'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<MoodService>(
        builder: (context, moodService, child) {
          final recentMoods = moodService.getRecentMoods();
          final analytics = moodService.getMoodAnalytics();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 32),
                _buildCurrentMoodSection(context),
                const SizedBox(height: 32),
                _buildMoodHistory(context, recentMoods),
                const SizedBox(height: 32),
                _buildMoodInsights(context, analytics),
                const SizedBox(height: 32),
                _buildMoodTips(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track Your Mood',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Monitor your emotional well-being over time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentMoodSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.emoji_happy,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'How are you feeling now?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MoodSelector(),
            const SizedBox(height: 16),
            _buildRecentMoodPreview(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMoodPreview(BuildContext context) {
    return Consumer<MoodService>(
      builder: (context, moodService, child) {
        final recentMoods = moodService.getRecentMoods();
        if (recentMoods.isEmpty) return const SizedBox();

        final latestMood = recentMoods.first;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.clock,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Last mood: ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_getMoodEmoji(latestMood.mood)} ${latestMood.mood}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _formatTime(latestMood.dateTime),
                style: const TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodHistory(BuildContext context, List<MoodEntry> recentMoods) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.chart_1,
                      color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mood History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            recentMoods.isEmpty
                ? _buildEmptyMoodHistory()
                : Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: MoodChart(moodEntries: recentMoods),
                      ),
                      const SizedBox(height: 20),
                      _buildMoodHistoryList(recentMoods),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMoodHistory() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Icon(Iconsax.chart, size: 64, color: AppColors.textDisabled),
          SizedBox(height: 16),
          Text(
            'No mood history yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start tracking your mood to see your patterns',
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodHistoryList(List<MoodEntry> moods) {
    return Column(
      children: moods.take(5).map((mood) {
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getMoodColor(mood.mood).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getMoodEmoji(mood.mood),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          title: Text(
            mood.mood,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            _formatDate(mood.dateTime),
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Text(
            _formatTime(mood.dateTime),
            style: const TextStyle(
              color: AppColors.textDisabled,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodInsights(
      BuildContext context, Map<String, dynamic> analytics) {
    final distribution = analytics['moodDistribution'] ?? {};
    final totalEntries = analytics['totalEntries'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.ranking_1,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mood Insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (totalEntries == 0)
              _buildEmptyInsights()
            else
              Column(
                children: [
                  _buildInsightItem(
                      'Total Entries', '$totalEntries', Iconsax.note),
                  _buildInsightItem('Most Common Mood',
                      _getMostCommonMood(distribution), Iconsax.star),
                  _buildInsightItem('Tracking Streak',
                      '${_calculateStreak(analytics)} days', Iconsax.calendar),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyInsights() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Column(
        children: [
          Icon(Iconsax.info_circle, size: 48, color: AppColors.textDisabled),
          SizedBox(height: 12),
          Text(
            'Track more moods to see insights',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMoodTips() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.lamp_charge,
                      color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mood Tracking Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTipItem('🎯', 'Track your mood at consistent times each day'),
            _buildTipItem('📝', 'Add notes to understand context and patterns'),
            _buildTipItem('📊', 'Review your mood charts weekly for insights'),
            _buildTipItem('🌱', 'Celebrate progress and be kind to yourself'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ADD THIS MISSING METHOD
  String _getMoodEmoji(String mood) {
    final emojis = {
      'Happy': '😊',
      'Calm': '😌',
      'Sad': '😢',
      'Anxious': '😰',
      'Angry': '😠',
    };
    return emojis[mood] ?? '😐';
  }

  Color _getMoodColor(String mood) {
    final colors = {
      'Happy': AppColors.happy,
      'Calm': AppColors.calm,
      'Sad': AppColors.sad,
      'Anxious': AppColors.anxious,
      'Angry': AppColors.angry,
    };
    return colors[mood] ?? AppColors.primary;
  }

  String _getMostCommonMood(Map<String, dynamic> distribution) {
    if (distribution.isEmpty) return 'None';
    final sorted = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  int _calculateStreak(Map<String, dynamic> analytics) {
    final totalEntries = analytics['totalEntries'] ?? 0;
    return (totalEntries / 7).ceil().clamp(0, 30);
  }
}
