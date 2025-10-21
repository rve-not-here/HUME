import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mood_service.dart';
import '../theme/colors.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights & Patterns')),
      body: Consumer<MoodService>(
        builder: (context, moodService, child) {
          final analytics = moodService.getMoodAnalytics();
          final stats = moodService.getStorageStatistics();

          return _InsightsContent(
            analytics: analytics,
            storageStats: stats,
          );
        },
      ),
    );
  }
}

class _InsightsContent extends StatelessWidget {
  final Map<String, dynamic> analytics;
  final Future<Map<String, dynamic>> storageStats;

  const _InsightsContent({
    required this.analytics,
    required this.storageStats,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryCard(analytics: analytics),
          const SizedBox(height: 16),
          _MoodDistributionCard(analytics: analytics),
          const SizedBox(height: 16),
          _WeeklyTrendsCard(analytics: analytics),
          const SizedBox(height: 16),
          _StorageInfoCard(storageStats: storageStats),
          const SizedBox(height: 16),
          _QuickTipsCard(),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const _SummaryCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emotional Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Total Entries',
                  value: '${analytics['totalEntries'] ?? 0}',
                ),
                _StatItem(
                  label: 'Avg Intensity',
                  value:
                      '${(analytics['averageIntensityOverall'] ?? 0).toStringAsFixed(1)}/5',
                ),
                _StatItem(
                  label: 'Days Tracked',
                  value: '${_calculateDaysTracked(analytics)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _MoodDistributionCard extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const _MoodDistributionCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final distribution = analytics['moodDistribution'] ?? {};
    final totalEntries = analytics['totalEntries'] ?? 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Distribution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (distribution.isEmpty)
              const Text('No mood data yet. Start tracking to see insights!')
            else
              Column(
                children:
                    _buildMoodDistributionItems(distribution, totalEntries),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMoodDistributionItems(
      Map<dynamic, dynamic> distribution, int total) {
    return distribution.entries.map<Widget>((entry) {
      return _MoodDistributionItem(
        mood: entry.key.toString(),
        count: entry.value is int
            ? entry.value
            : int.tryParse(entry.value.toString()) ?? 0,
        total: total,
      );
    }).toList();
  }
}

class _MoodDistributionItem extends StatelessWidget {
  final String mood;
  final int count;
  final int total;

  const _MoodDistributionItem({
    required this.mood,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (count / total * 100).round();
    final emoji = _MoodHelper.getEmoji(mood);
    final color = _MoodHelper.getColor(mood);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$emoji $mood',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LinearProgressIndicator(
                value: count / total,
                backgroundColor: Colors.grey[200],
                color: color,
              ),
            ),
          ),
          Text('$percentage% ($count)'),
        ],
      ),
    );
  }
}

class _WeeklyTrendsCard extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const _WeeklyTrendsCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final weeklyTrends = analytics['weeklyTrends'] ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week\'s Trends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (weeklyTrends.isEmpty)
              const Text('No data for this week yet.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildMoodChips(weeklyTrends),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMoodChips(Map<dynamic, dynamic> weeklyTrends) {
    return weeklyTrends.entries.map<Widget>((entry) {
      return _MoodChip(
        mood: entry.key.toString(),
        count: entry.value is int
            ? entry.value
            : int.tryParse(entry.value.toString()) ?? 0,
      );
    }).toList();
  }
}

class _MoodChip extends StatelessWidget {
  final String mood;
  final int count;

  const _MoodChip({
    required this.mood,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = _MoodHelper.getEmoji(mood);
    final color = _MoodHelper.getColor(mood);

    return Chip(
      label: Text('$emoji ${count}x'),
      backgroundColor: color.withValues(alpha: 0.2),
    );
  }
}

class _StorageInfoCard extends StatelessWidget {
  final Future<Map<String, dynamic>> storageStats;

  const _StorageInfoCard({required this.storageStats});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: storageStats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final data = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Data',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _StorageListItem(
                  icon: Icons.mood,
                  color: AppColors.primary,
                  title: 'Mood Entries',
                  value: '${data['mood_entries_count'] ?? 0}',
                ),
                _StorageListItem(
                  icon: Icons.edit,
                  color: AppColors.secondary,
                  title: 'Journal Entries',
                  value: '${data['journal_entries_count'] ?? 0}',
                ),
                _StorageListItem(
                  icon: Icons.storage,
                  color: AppColors.secondary,
                  title: 'Total Entries',
                  value: '${data['total_entries'] ?? 0}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StorageListItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _StorageListItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(value),
    );
  }
}

class _QuickTipsCard extends StatelessWidget {
  final List<Map<String, String>> tips = const [
    {
      'emoji': '💡',
      'text': 'Try to log your mood at the same time each day for consistency'
    },
    {
      'emoji': '📝',
      'text': 'Journaling about positive experiences can boost your mood'
    },
    {
      'emoji': '🌱',
      'text': 'Notice patterns in your mood to understand your triggers'
    },
    {'emoji': '🎯', 'text': 'Set small, achievable emotional wellness goals'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Wellness Tips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => _TipItem(
                  emoji: tip['emoji']!,
                  text: tip['text']!,
                )),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String emoji;
  final String text;

  const _TipItem({
    required this.emoji,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MoodHelper {
  static const Map<String, String> _emojis = {
    'Happy': '😊',
    'Calm': '😌',
    'Sad': '😢',
    'Anxious': '😰',
    'Angry': '😠',
  };

  static const Map<String, Color> _colors = {
    'Happy': AppColors.happy,
    'Calm': AppColors.calm,
    'Sad': AppColors.sad,
    'Anxious': AppColors.anxious,
    'Angry': AppColors.angry,
  };

  static String getEmoji(String mood) => _emojis[mood] ?? '';
  static Color getColor(String mood) => _colors[mood] ?? Colors.grey;
}

int _calculateDaysTracked(Map<String, dynamic> analytics) {
  final totalEntries = analytics['totalEntries'] ?? 0;
  return (totalEntries / 3).ceil();
}
