import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';
import '../../../app/routes.dart';
import '../../screens/home/main_screen.dart';
import '../../screens/navigation/activity_selection_screen.dart';
import '../../screens/progress_gallery/progress_gallery_screen.dart';
import '../../screens/profile/profile_screen.dart';
import 'navigation_tab_button.dart';

/// Main bottom navigation container with floating action button
///
/// Features:
/// - 4 main tabs: Home, Activity, Progress, Profile
/// - Center floating action button for search/quick actions
/// - Page storage for maintaining scroll positions
/// - Smooth tab transitions with state management
/// - Clean and modern design with shadows and gradients
class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedTabIndex = 0;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  Widget _currentScreen = const MainScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: _pageStorageBucket, child: _currentScreen),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryColor1.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: _handleSearchButtonTap,
          child: Icon(Icons.search, color: TColor.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      elevation: 8,
      notchMargin: 8,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        height: kToolbarHeight,
        child: _buildTabButtonsRow(),
      ),
    );
  }

  Widget _buildTabButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildHomeTab(),
        _buildActivityTab(),
        const SizedBox(width: 40), // Space for floating action button
        _buildProgressTab(),
        _buildProfileTab(),
      ],
    );
  }

  Widget _buildHomeTab() {
    return NavigationTabButton(
      iconPath: "assets/img/home_tab.png",
      activeIconPath: "assets/img/home_tab_select.png",
      isSelected: _selectedTabIndex == 0,
      onPressed: () => _switchToTab(0, const MainScreen()),
    );
  }

  Widget _buildActivityTab() {
    return NavigationTabButton(
      iconPath: "assets/img/activity_tab.png",
      activeIconPath: "assets/img/activity_tab_select.png",
      isSelected: _selectedTabIndex == 1,
      onPressed: () => _switchToTab(1, const ActivitySelectionScreen()),
    );
  }

  Widget _buildProgressTab() {
    return NavigationTabButton(
      iconPath: "assets/img/camera_tab.png",
      activeIconPath: "assets/img/camera_tab_select.png",
      isSelected: _selectedTabIndex == 2,
      onPressed: () => _switchToTab(2, const ProgressGalleryScreen()),
    );
  }

  Widget _buildProfileTab() {
    return NavigationTabButton(
      iconPath: "assets/img/profile_tab.png",
      activeIconPath: "assets/img/profile_tab_select.png",
      isSelected: _selectedTabIndex == 3,
      onPressed: () => _switchToTab(3, const ProfileScreen()),
    );
  }

  void _switchToTab(int tabIndex, Widget screen) {
    if (_selectedTabIndex != tabIndex) {
      setState(() {
        _selectedTabIndex = tabIndex;
        _currentScreen = screen;
      });
    }
  }

  void _handleSearchButtonTap() {
    // Navigate to notification screen or implement search functionality
    Navigator.pushNamed(context, Routes.notificationScreen);
  }
}
