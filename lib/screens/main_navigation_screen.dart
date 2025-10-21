import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'home_screen.dart';
import 'mood_tracking_screen.dart';
import 'journal_screen.dart';
import 'insights_screen.dart';
import 'profile_screen.dart';
import '../theme/colors.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<AnimationController> _animationControllers;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MoodTrackingScreen(),
    const JournalScreen(),
    InsightsScreen(),
    const ProfileScreen(),
  ];

  final List<NavItem> _navItems = const [
    NavItem(
      icon: Iconsax.home_2,
      activeIcon: Iconsax.home_25,
      label: 'Home',
      color: AppColors.primary,
    ),
    NavItem(
      icon: Iconsax.heart,
      activeIcon: Iconsax.heart5,
      label: 'Mood',
      color: Color(0xFFEF4444),
    ),
    NavItem(
      icon: Iconsax.edit_2,
      activeIcon: Iconsax.edit_25,
      label: 'Journal',
      color: Color(0xFF8B5CF6),
    ),
    NavItem(
      icon: Iconsax.chart_2,
      activeIcon: Iconsax.chart_215,
      label: 'Insights',
      color: Color(0xFF06B6D4),
    ),
    NavItem(
      icon: Iconsax.profile_circle,
      activeIcon: Iconsax.profile_circle5,
      label: 'Profile',
      color: Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    _animationControllers[0].forward();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _animationControllers[_selectedIndex].reverse();
      _selectedIndex = index;
      _animationControllers[index].forward();
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _animationControllers[_selectedIndex].reverse();
            _selectedIndex = index;
            _animationControllers[index].forward();
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _NavItem(
                item: _navItems[index],
                isSelected: _selectedIndex == index,
                animationController: _animationControllers[index],
                onTap: () => _onItemTapped(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final AnimationController animationController;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: item.label,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final animation = CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOut,
            );

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 24,
                    color: ColorTween(
                      begin: const Color(0xFF8E8E93),
                      end: item.color,
                    ).evaluate(animation),
                  ),
                  const SizedBox(height: 2),
                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: ColorTween(
                        begin: const Color(0xFF8E8E93),
                        end: item.color,
                      ).evaluate(animation),
                      letterSpacing: -0.1,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
