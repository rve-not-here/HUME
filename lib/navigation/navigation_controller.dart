import 'package:flutter/foundation.dart';

class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateToTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void navigateToHome() => navigateToTab(0);
  void navigateToMood() => navigateToTab(1);
  void navigateToJournal() => navigateToTab(2);
  void navigateToInsights() => navigateToTab(3);
  void navigateToProfile() => navigateToTab(4);
}
