import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/colors.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  final List<Map<String, dynamic>> _meditations = const [
    {
      'title': 'Box Breathing',
      'duration': '5 mins',
      'description': 'Military technique for stress relief and focus',
      'type': 'breathing',
      'icon': Iconsax.wind,
      'color': AppColors.primary,
      'instructions': [
        'Inhale slowly for 4 seconds',
        'Hold your breath for 4 seconds',
        'Exhale slowly for 4 seconds',
        'Hold empty for 4 seconds',
        'Repeat for 5 minutes'
      ],
    },
    {
      'title': 'Body Scan Meditation',
      'duration': '10 mins',
      'description': 'Progressive relaxation from head to toe',
      'type': 'meditation',
      'icon': Iconsax.health,
      'color': AppColors.secondary,
      'instructions': [
        'Lie down comfortably',
        'Focus attention on your toes',
        'Slowly move up through each body part',
        'Notice sensations without judgment',
        'Release tension as you go'
      ],
    },
    {
      'title': '4-7-8 Breathing',
      'duration': '8 mins',
      'description': 'Calming technique for anxiety and sleep',
      'type': 'breathing',
      'icon': Iconsax.wind,
      'color': AppColors.warning,
      'instructions': [
        'Inhale quietly through nose for 4 seconds',
        'Hold breath for 7 seconds',
        'Exhale completely through mouth for 8 seconds',
        'Repeat cycle 4 times'
      ],
    },
    {
      'title': 'Mindful Breathing',
      'duration': '15 mins',
      'description': 'Basic mindfulness practice for daily calm',
      'type': 'meditation',
      'icon': Iconsax.heart,
      'color': AppColors.calm,
      'instructions': [
        'Sit comfortably with straight back',
        'Focus on natural breath rhythm',
        'When mind wanders, gently return to breath',
        'Observe thoughts without attachment',
        'Practice non-judgmental awareness'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mindful Practices',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Your Center',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select a practice to cultivate mindfulness and reduce stress',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Meditation List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _meditations.length,
              itemBuilder: (context, index) {
                final meditation = _meditations[index];
                return _buildMeditationCard(context, meditation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(
      BuildContext context, Map<String, dynamic> meditation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            meditation['color'].withOpacity(0.1),
            meditation['color'].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showMeditationDetails(context, meditation),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: meditation['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    meditation['icon'],
                    color: meditation['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meditation['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        meditation['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Iconsax.clock,
                              size: 16, color: AppColors.textDisabled),
                          const SizedBox(width: 6),
                          Text(
                            meditation['duration'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textDisabled,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: meditation['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              meditation['type'],
                              style: TextStyle(
                                fontSize: 11,
                                color: meditation['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Iconsax.arrow_right_3,
                    color: meditation['color'], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMeditationDetails(
      BuildContext context, Map<String, dynamic> meditation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MeditationDetailsModal(meditation: meditation),
    );
  }
}

class MeditationDetailsModal extends StatelessWidget {
  final Map<String, dynamic> meditation;

  const MeditationDetailsModal({super.key, required this.meditation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textDisabled.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: meditation['color'].withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(meditation['icon'],
                  size: 48, color: meditation['color']),
            ),
            const SizedBox(height: 24),
            Text(
              meditation['title'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              meditation['duration'],
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      meditation['description'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...meditation['instructions']
                        .map<Widget>((instruction) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 4, right: 12),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: meditation['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      instruction,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startMeditationPractice(context, meditation);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: meditation['color'],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start Practice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Not Now',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startMeditationPractice(
      BuildContext context, Map<String, dynamic> meditation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationPracticeScreen(meditation: meditation),
      ),
    );
  }
}

class MeditationPracticeScreen extends StatefulWidget {
  final Map<String, dynamic> meditation;

  const MeditationPracticeScreen({super.key, required this.meditation});

  @override
  State<MeditationPracticeScreen> createState() =>
      _MeditationPracticeScreenState();
}

class _MeditationPracticeScreenState extends State<MeditationPracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Finish'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated breathing circle would go here
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: widget.meditation['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  widget.meditation['icon'],
                  size: 64,
                  color: widget.meditation['color'],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              widget.meditation['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow your breath...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(widget.meditation['color']),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
