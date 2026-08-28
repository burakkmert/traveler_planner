import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations_provider.dart';
import '../../../../core/navigation/navigation_provider.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../explore/presentation/screens/explore_screen.dart';
import '../../../planner/presentation/screens/planner_screen.dart';
import '../../../saved/presentation/screens/saved_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class MainWrapperScreen extends ConsumerWidget {
  const MainWrapperScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    PlannerScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationTabProvider);
    final loc = ref.watch(locProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationTabProvider.notifier).setTab(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore_rounded),
            label: loc.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map_rounded),
            label: loc.exploreTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome_rounded),
            label: loc.isTurkish ? 'Optimizer' : 'Optimizer',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline_rounded),
            activeIcon: const Icon(Icons.bookmark_rounded),
            label: loc.savedTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: loc.isTurkish ? 'Profil' : 'Profile',
          ),
        ],
      ),
    );
  }
}
