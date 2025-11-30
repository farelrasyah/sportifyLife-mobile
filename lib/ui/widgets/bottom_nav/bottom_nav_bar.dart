import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../screens/home/main_screen.dart';
import '../../screens/navigation/activity_selection_screen.dart';
import '../../screens/progress_gallery/progress_gallery_screen.dart';
import '../../screens/profile/profile_screen.dart';

/// Main bottom navigation container with floating action button
class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedTabIndex = 0;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  final List<Widget> _screens = [
    const MainScreen(),
    const ActivitySelectionScreen(),
    const ProgressGalleryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: _screens[_selectedTabIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _handleSearchButtonTap,
      backgroundColor: const Color(0xFF92A3FD),
      child: const Icon(Icons.search, color: Colors.white),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      elevation: 8,
      notchMargin: 8,
      color: Colors.white,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(Icons.home, 0, 'Home'),
            _buildTabItem(Icons.fitness_center, 1, 'Activity'),
            const SizedBox(width: 40), // Space for FAB
            _buildTabItem(Icons.photo_camera, 2, 'Progress'),
            _buildTabItem(Icons.person, 3, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, int index, String label) {
    final isSelected = _selectedTabIndex == index;
    final color = isSelected ? const Color(0xFF92A3FD) : Colors.grey;

    return GestureDetector(
      onTap: () => _switchToTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchToTab(int index) {
    if (_selectedTabIndex != index) {
      setState(() {
        _selectedTabIndex = index;
      });
    }
  }

  void _handleSearchButtonTap() {
    // Navigate to notification screen
    Navigator.pushNamed(context, Routes.notificationScreen);
  }
}
