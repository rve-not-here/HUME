// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mood_service.dart';
import 'services/local_storage.dart';
import 'navigation/navigation_controller.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorageService();
  await localStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: Added NavigationController to providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoodService()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationController(),
        ),
      ],
      child: MaterialApp(
        title: 'HUME - Emotional Companion',
        theme: AppTheme.lightTheme,
        home: const AppLoadingScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moodService = Provider.of<MoodService>(context);

    if (moodService.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 20),
              Text(
                'Loading your emotional data...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (moodService.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 20),
                Text(
                  moodService.errorMessage!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => moodService.initialize(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const MainNavigationScreen();
  }
}
