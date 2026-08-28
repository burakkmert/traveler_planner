import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier managing BottomNavigationBar active tab index globally.
class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setTab(int index) {
    if (index >= 0 && index <= 4) {
      state = index;
    }
  }
}

/// Global Riverpod provider for active navigation tab index.
final navigationTabProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});
