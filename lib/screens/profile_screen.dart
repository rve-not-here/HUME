import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../services/mood_service.dart';
import '../theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Consumer<MoodService>(
        builder: (context, moodService, child) {
          final stats = moodService.getStorageStatistics();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 32),
                _buildQuickStats(stats),
                const SizedBox(height: 24),
                _buildAppSettings(),
                const SizedBox(height: 24),
                _buildSupportSection(context),
                const SizedBox(height: 32),
                _buildAppInfo(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Iconsax.user,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Alex Morgan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mental Wellness Journey',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '42 Days Streak 🔥',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(Future<Map<String, dynamic>> stats) {
    return FutureBuilder<Map<String, dynamic>>(
      future: stats,
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

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
                      child: const Icon(Iconsax.chart_success,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Your Progress',
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
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    _buildStatCard(
                      'Mood Entries',
                      '${data['mood_entries_count'] ?? 0}',
                      Iconsax.emoji_happy,
                      AppColors.primary,
                    ),
                    _buildStatCard(
                      'Journal Entries',
                      '${data['journal_entries_count'] ?? 0}',
                      Iconsax.edit_2,
                      AppColors.secondary,
                    ),
                    _buildStatCard(
                      'Meditation',
                      '12 hrs',
                      Iconsax.heart,
                      const Color(0xFFF59E0B),
                    ),
                    _buildStatCard(
                      'Current Streak',
                      '42 days',
                      Iconsax.calendar_1,
                      const Color(0xFF06B6D4),
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

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettings() {
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
                  child: const Icon(Iconsax.setting,
                      color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'App Settings',
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
            _buildSettingItem(
              'Daily Reminders',
              'Get reminded to track your mood',
              Iconsax.notification,
              true,
              (value) => _toggleReminders(value),
            ),
            _buildSettingItem(
              'Dark Mode',
              'Switch to dark theme',
              Iconsax.moon,
              false,
              (value) => _toggleDarkMode(value),
            ),
            _buildSettingItem(
              'Cloud Backup',
              'Backup your data securely',
              Iconsax.cloud,
              true,
              (value) => _toggleCloudBackup(value),
            ),
            _buildSettingItem(
              'Weekly Reports',
              'Receive weekly insights',
              Iconsax.chart,
              false,
              (value) => _toggleWeeklyReports(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
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
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.support,
                      color: Color(0xFF06B6D4), size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Support & Resources',
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
            _buildSupportItem(
              'Help Center',
              Iconsax.message_question,
              () => _showHelpCenter(context),
            ),
            _buildSupportItem(
              'Contact Support',
              Iconsax.message,
              () => _contactSupport(context),
            ),
            _buildSupportItem(
              'Privacy Policy',
              Iconsax.shield_tick,
              () => _showPrivacyPolicy(context),
            ),
            _buildSupportItem(
              'About Hume',
              Iconsax.info_circle,
              () => _showAbout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3,
          size: 18, color: AppColors.textDisabled),
      onTap: onTap,
    );
  }

  Widget _buildAppInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text(
            'HUME v1.0.0',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Your Emotional Companion',
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Made with ❤️ for mental wellness',
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _showSettings(BuildContext context) {
    // Implement settings navigation
  }

  void _toggleReminders(bool value) {
    // Implement reminder toggle
  }

  void _toggleDarkMode(bool value) {
    // Implement dark mode toggle
  }

  void _toggleCloudBackup(bool value) {
    // Implement cloud backup toggle
  }

  void _toggleWeeklyReports(bool value) {
    // Implement weekly reports toggle
  }

  void _showHelpCenter(BuildContext context) {
    // Implement help center navigation
  }

  void _contactSupport(BuildContext context) {
    // Implement contact support
  }

  void _showPrivacyPolicy(BuildContext context) {
    // Implement privacy policy
  }

  void _showAbout(BuildContext context) {
    // Implement about dialog
  }
}
