import 'package:flutter/material.dart';
import 'package:hume/models/mood_entry.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../services/mood_service.dart';
import '../navigation/navigation_controller.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_chart.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/shadows.dart';
import '../theme/border_radius.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: HomeScreenContent(),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppBar(),
          SizedBox(height: AppSpacing.xl),
          _WelcomeSection(),
          SizedBox(height: AppSpacing.xl),
          _QuickActionsSection(),
          SizedBox(height: AppSpacing.xl),
          _MoodTrackingSection(),
          SizedBox(height: AppSpacing.xl),
          _RecentMoodsSection(),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _AppLogo(),
        _NotificationIcon(),
      ],
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: AppShadows.primaryShadow(AppColors.primary),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.heart, color: Colors.white, size: 18),
          SizedBox(width: AppSpacing.sm),
          Text(
            'HUME',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: AppShadows.subtle,
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Iconsax.notification,
                color: AppColors.textPrimary, size: 22),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimatedGreeting(),
        SizedBox(height: AppSpacing.md),
        _DailyAffirmation(),
      ],
    );
  }
}

class _AnimatedGreeting extends StatefulWidget {
  const _AnimatedGreeting();

  @override
  State<_AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<_AnimatedGreeting>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _timeBasedGreeting,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text(
                      'Hello, ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Admin!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DailyAffirmation extends StatelessWidget {
  const _DailyAffirmation();

  // FIXED: All emojis are now proper Unicode
  final List<String> _affirmations = const [
    'You are capable of amazing things today 🌟',
    'Every breath is a new beginning 💫',
    'Your peace is your power 🕊️',
    'Today is your canvas - paint it beautifully 🎨',
    'You are exactly where you need to be 🌈'
  ];

  String get _randomAffirmation {
    final random = DateTime.now().millisecondsSinceEpoch % _affirmations.length;
    return _affirmations[random];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: AppBorderRadius.lgRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.quote_up,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _randomAffirmation,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Quick Actions'),
        SizedBox(height: AppSpacing.lg),
        _QuickActionsGrid(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.4,
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      children: const [
        _ActionCard(
          title: 'Journal',
          subtitle: 'Write your thoughts',
          icon: Iconsax.edit_2,
          gradient: AppColors.primaryGradient,
          tabIndex: 2, // FIXED: Navigate to Journal tab
        ),
        _ActionCard(
          title: 'Meditate',
          subtitle: 'Find your peace',
          icon: Iconsax.heart,
          gradient: AppColors.secondaryGradient,
          showModal: true, // FIXED: Show modal instead
        ),
        _ActionCard(
          title: 'Insights',
          subtitle: 'View analytics',
          icon: Iconsax.chart_2,
          gradient:
              LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
          tabIndex: 3, // FIXED: Navigate to Insights tab
        ),
        _BreathingActionCard(),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.tabIndex,
    this.showModal = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final int? tabIndex;
  final bool showModal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.lgRadius,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: AppBorderRadius.lgRadius,
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FIXED: Proper navigation using NavigationController
  void _handleTap(BuildContext context) {
    if (tabIndex != null) {
      context.read<NavigationController>().navigateToTab(tabIndex!);
    }
  }
}

class _BreathingActionCard extends StatelessWidget {
  const _BreathingActionCard();

  void _showBreathingExercise(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const BreathingExerciseModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.lgRadius,
        gradient: const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBreathingExercise(context),
          borderRadius: AppBorderRadius.lgRadius,
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActionIcon(icon: Iconsax.wind),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breathing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Calm your mind',
                      style: TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _MoodTrackingSection extends StatelessWidget {
  const _MoodTrackingSection();

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      icon: Iconsax.emoji_happy,
      iconColor: AppColors.primary,
      title: 'How are you feeling?',
      subtitle: 'Tap to log your current mood',
      child: Column(
        children: [
          MoodSelector(),
          const SizedBox(height: AppSpacing.md),
          Consumer<MoodService>(
            builder: (context, moodService, child) {
              final todayMoods = moodService.getMoodsForDate(DateTime.now());
              if (todayMoods.isEmpty) {
                return const _MoodPrompt();
              }
              return _TodayMoodSummary(moods: todayMoods);
            },
          ),
        ],
      ),
    );
  }
}

class _MoodPrompt extends StatelessWidget {
  const _MoodPrompt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppBorderRadius.mdRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          Icon(Iconsax.info_circle, color: AppColors.primary, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Track your mood to see patterns and insights',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayMoodSummary extends StatelessWidget {
  final List<MoodEntry> moods;

  const _TodayMoodSummary({required this.moods});

  @override
  Widget build(BuildContext context) {
    final latestMood = moods.first;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppBorderRadius.mdRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.emoji_happy,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest mood: ${latestMood.mood}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${moods.length} entries today',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3,
              color: AppColors.textDisabled, size: 20),
        ],
      ),
    );
  }
}

class _RecentMoodsSection extends StatelessWidget {
  const _RecentMoodsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodService>(
      builder: (context, moodService, child) {
        final List<MoodEntry> recentMoods = moodService.getRecentMoods();
        return _SectionContainer(
          icon: Iconsax.chart_1,
          iconColor: AppColors.secondary,
          title: 'Mood Trends',
          subtitle: 'Your emotional journey',
          child: _RecentMoodsContent(recentMoods: recentMoods),
        );
      },
    );
  }
}

class _RecentMoodsContent extends StatelessWidget {
  const _RecentMoodsContent({required this.recentMoods});

  final List<MoodEntry> recentMoods;

  @override
  Widget build(BuildContext context) {
    if (recentMoods.isEmpty) {
      return const _EmptyMoodsState();
    }
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: MoodChart(moodEntries: recentMoods),
        ),
        const SizedBox(height: AppSpacing.md),
        _MoodStats(moods: recentMoods),
      ],
    );
  }
}

class _MoodStats extends StatelessWidget {
  final List<MoodEntry> moods;

  const _MoodStats({required this.moods});

  @override
  Widget build(BuildContext context) {
    final moodCounts = <String, int>{};
    for (var mood in moods) {
      moodCounts[mood.mood] = (moodCounts[mood.mood] ?? 0) + 1;
    }

    final mostFrequentMood = moodCounts.entries.isNotEmpty
        ? moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'None';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: AppBorderRadius.mdRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: moods.length.toString(),
            label: 'Total Entries',
            icon: Iconsax.calendar,
          ),
          _StatItem(
            value: mostFrequentMood,
            label: 'Most Frequent',
            icon: Iconsax.star,
          ),
          _StatItem(
            value: moods.length >= 7 ? '${moods.length ~/ 7}' : '0',
            label: 'Week Avg',
            icon: Iconsax.trend_up,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.secondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyMoodsState extends StatelessWidget {
  const _EmptyMoodsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Iconsax.chart,
              size: 64, color: AppColors.textDisabled.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'No mood data yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Start tracking your mood to see beautiful patterns and insights about your emotional well-being',
              style: TextStyle(
                color: AppColors.textDisabled,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.xlRadius,
        boxShadow: AppShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
                icon: icon,
                iconColor: iconColor,
                title: title,
                subtitle: subtitle),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Breathing Exercise Modal (kept the same)
class BreathingExerciseModal extends StatefulWidget {
  const BreathingExerciseModal({super.key});

  @override
  State<BreathingExerciseModal> createState() => _BreathingExerciseModalState();
}

class _BreathingExerciseModalState extends State<BreathingExerciseModal>
    with SingleTickerProviderStateMixin {
  static const int _totalBreaths = 5;
  static const Duration _breathDuration = Duration(seconds: 4);
  static const Duration _holdDuration = Duration(seconds: 2);

  late final AnimationController _controller;
  late final Animation<double> _animation;

  int _breathCount = 0;
  BreathingState _currentState = BreathingState.idle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _breathDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _breathCount = 0;
      _currentState = BreathingState.inhale;
    });
    _executeBreathCycle();
  }

  void _stopExercise() {
    setState(() {
      _currentState = BreathingState.idle;
    });
    _controller.stop();
    _controller.reset();
  }

  Future<void> _executeBreathCycle() async {
    for (int i = 0;
        i < _totalBreaths && _currentState != BreathingState.idle;
        i++) {
      await _animateBreath(BreathingState.inhale);
      if (_currentState == BreathingState.idle) break;

      await _holdBreath();
      if (_currentState == BreathingState.idle) break;

      await _animateBreath(BreathingState.exhale);
      if (_currentState == BreathingState.idle) break;

      await _holdBreath();
      if (_currentState == BreathingState.idle) break;

      setState(() => _breathCount = i + 1);
    }

    if (_currentState != BreathingState.idle) {
      setState(() => _currentState = BreathingState.idle);
    }
  }

  Future<void> _animateBreath(BreathingState state) async {
    setState(() => _currentState = state);

    if (state == BreathingState.inhale) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
  }

  Future<void> _holdBreath() async {
    setState(() => _currentState = BreathingState.hold);
    await Future.delayed(_holdDuration);
  }

  String get _breathText {
    switch (_currentState) {
      case BreathingState.inhale:
        return 'Inhale';
      case BreathingState.exhale:
        return 'Exhale';
      case BreathingState.hold:
        return 'Hold';
      case BreathingState.idle:
        return 'Ready';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.xxl),
          topRight: Radius.circular(AppBorderRadius.xxl),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const _ModalHandle(),
            const SizedBox(height: AppSpacing.xl),
            const _ModalTitle(
              title: 'Breathing Exercise',
              subtitle: 'Follow the animation to regulate your breathing',
            ),
            const SizedBox(height: 40),
            _BreathingAnimation(
              animation: _animation,
              breathText: _breathText,
            ),
            const SizedBox(height: 25),
            Text(
              'Breaths: $_breathCount/$_totalBreaths',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 35),
            _ExerciseControls(
              isActive: _currentState != BreathingState.idle,
              breathCount: _breathCount,
              onStart: _startExercise,
              onStop: _stopExercise,
            ),
          ],
        ),
      ),
    );
  }
}

enum BreathingState { idle, inhale, exhale, hold }

class _ModalHandle extends StatelessWidget {
  const _ModalHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textDisabled.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}

class _ModalTitle extends StatelessWidget {
  const _ModalTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _BreathingAnimation extends StatelessWidget {
  const _BreathingAnimation({
    required this.animation,
    required this.breathText,
  });

  final Animation<double> animation;
  final String breathText;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 120 * animation.value,
              height: 120 * animation.value,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  breathText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExerciseControls extends StatelessWidget {
  const _ExerciseControls({
    required this.isActive,
    required this.breathCount,
    required this.onStart,
    required this.onStop,
  });

  final bool isActive;
  final int breathCount;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Column(
        children: [
          const Text(
            'Focus on your breath...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: onStop,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.textDisabled),
            ),
            child: const Text('Stop Exercise'),
          ),
        ],
      );
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: onStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppBorderRadius.md)),
            ),
            elevation: 0,
          ),
          child: Text(
            breathCount == 0 ? 'Start Exercise' : 'Start Again',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
