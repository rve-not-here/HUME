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
import 'meditation_screen.dart';
import '../services/auth_service.dart';

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
          _QuickActionsGridSection(),
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
    final authService = Provider.of<AuthService>(context);
    final userName = authService.firstName;

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
                Row(
                  children: [
                    const Text(
                      'Hello, ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '$userName!',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.8,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
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

class _QuickActionsGridSection extends StatelessWidget {
  const _QuickActionsGridSection();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        children: [
          _ActionCard(
            title: 'Meditate',
            subtitle: 'Find your peace',
            icon: Iconsax.heart,
            gradient: AppColors.primaryGradient,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MeditationScreen(),
                ),
              );
            },
          ),
          _ActionCard(
            title: 'Breathing',
            subtitle: 'Calm your mind',
            icon: Iconsax.wind,
            gradient: const LinearGradient(
              colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const BreathingExerciseModal(),
              );
            },
          ),
          _ActionCard(
            title: 'Gratitude',
            subtitle: 'Count your blessings',
            icon: Iconsax.heart_add,
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              _showGratitudePrompt(context);
            },
          ),
          _ActionCard(
            title: 'Self-Care',
            subtitle: 'Quick wellness tips',
            icon: Iconsax.lovely,
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              _showSelfCareTips(context);
            },
          ),
        ],
      ),
    );
  }

  void _showGratitudePrompt(BuildContext context) {
    final TextEditingController gratitudeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xxl),
            topRight: Radius.circular(AppBorderRadius.xxl),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textDisabled.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.heart_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              const Text(
                'Gratitude Journal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'What are you grateful for today?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Input Field
              Expanded(
                child: TextField(
                  controller: gratitudeController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText:
                        'I am grateful for...\n\n• My health\n• My family\n• Today\'s sunshine',
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (gratitudeController.text.trim().isNotEmpty) {
                    // Save to journal or separate gratitude list
                    final moodService =
                        Provider.of<MoodService>(context, listen: false);
                    moodService.addJournalEntry(
                      title:
                          '🙏 Gratitude - ${DateTime.now().day}/${DateTime.now().month}',
                      content: gratitudeController.text.trim(),
                      mood: '😊 Happy',
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Gratitude saved! 🙏'),
                        backgroundColor: const Color(0xFFF59E0B),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Gratitude',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSelfCareTips(BuildContext context) {
    final List<Map<String, dynamic>> tips = [
      {
        'title': 'Take a Walk',
        'description': '10-15 minutes outdoors can boost your mood and energy',
        'icon': Iconsax.activity1,
        'color': const Color(0xFF10B981),
        'duration': '15 min',
      },
      {
        'title': 'Drink Water',
        'description': 'Stay hydrated for better focus and mental clarity',
        'icon': Iconsax.cup,
        'color': const Color(0xFF06B6D4),
        'duration': '2 min',
      },
      {
        'title': 'Stretch',
        'description': 'Release physical tension and improve circulation',
        'icon': Iconsax.activity,
        'color': const Color(0xFF8B5CF6),
        'duration': '5 min',
      },
      {
        'title': 'Connect',
        'description': 'Reach out to someone who makes you feel good',
        'icon': Iconsax.message_favorite,
        'color': const Color(0xFFEF4444),
        'duration': '10 min',
      },
      {
        'title': 'Power Nap',
        'description': 'A short rest can recharge your mind and body',
        'icon': Iconsax.moon,
        'color': const Color(0xFF6366F1),
        'duration': '20 min',
      },
      {
        'title': 'Listen to Music',
        'description': 'Play your favorite uplifting songs and unwind',
        'icon': Iconsax.music,
        'color': const Color(0xFFF59E0B),
        'duration': '10 min',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xxl),
            topRight: Radius.circular(AppBorderRadius.xxl),
          ),
        ),
        child: Column(
          children: [
            // Header Section with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.1),
                    const Color(0xFF34D399).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.xxl),
                  topRight: Radius.circular(AppBorderRadius.xxl),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Animated Icon
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF10B981),
                                    Color(0xFF34D399)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Iconsax.lovely,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      const Text(
                        'Self-Care Menu',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Choose what feels right today',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tips Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: _SelfCareTipCard(tip: tip),
                  );
                },
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Iconsax.arrow_left_2, size: 20),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: AppColors.textDisabled.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfCareTipCard extends StatelessWidget {
  final Map<String, dynamic> tip;

  const _SelfCareTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Could trigger specific actions here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${tip['title']} - ${tip['duration']}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tip['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Duration Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            tip['color'],
                            tip['color'].withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: tip['color'].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        tip['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tip['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tip['duration'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tip['color'],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Title
                Text(
                  tip['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  tip['description'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

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
          onTap: onTap,
          borderRadius: AppBorderRadius.lgRadius,
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
