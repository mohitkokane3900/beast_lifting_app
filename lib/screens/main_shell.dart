import 'package:flutter/material.dart';
import 'feed/feed_screen.dart';
import 'challenges/challenges_screen.dart';
import 'progress/progress_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainShell({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const FeedScreen(),
      const ChallengesScreen(),
      const ProgressScreen(),
      ProfileScreen(
        darkMode: widget.darkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
