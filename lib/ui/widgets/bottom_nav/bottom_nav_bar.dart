import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/home/main_screen.dart';
import '../../screens/navigation/activity_selection_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../theme/color_palette.dart';
import 'bottom_nav_painter.dart';

/// Main bottom navigation container with animated floating circle
class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  final double horizontalPadding = 40.0;
  final double horizontalMargin = 0.0; // Full width navbar

  late double position;
  late AnimationController controller;
  late Animation<double> animation;

  final List<Widget> _screens = [
    const MainScreen(),
    const ActivitySelectionScreen(),
    const ProfileScreen(),
  ];

  final List<_NavItem> _navItems = [
    const _NavItem(
      iconPath: 'assets/images/home.svg',
      activeIconPath: 'assets/images/home_active.svg',
      label: 'Home',
    ),
    const _NavItem(
      iconPath: 'assets/images/activity.svg',
      activeIconPath: 'assets/images/activity_active.svg',
      label: 'Activity',
    ),
    const _NavItem(
      iconPath: 'assets/images/profile.svg',
      activeIconPath: 'assets/images/profile_active.svg',
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    position = _getEndPosition(_selectedTabIndex);
    animation = Tween(begin: position, end: position).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double _getEndPosition(int index) {
    // Calculate the width of each item section
    double totalWidth =
        MediaQuery.of(context).size.width - (2 * horizontalMargin);
    double itemWidth =
        (totalWidth - (2 * horizontalPadding)) / _navItems.length;

    // Calculate the center position of the selected item
    double itemCenterX =
        horizontalPadding + (itemWidth * index) + (itemWidth / 2);

    // Center the circle on the item (subtract half the circle width)
    return itemCenterX - 70.0;
  }

  void _animateDrop(int index) {
    double newPosition = _getEndPosition(index);
    animation = Tween(
      begin: position,
      end: newPosition,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    controller.reset();
    controller.forward().then((value) {
      position = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: _screens[_selectedTabIndex],
      ),
      extendBody: true,
      bottomNavigationBar: _buildAnimatedBottomNavigation(),
    );
  }

  Widget _buildAnimatedBottomNavigation() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: AppBarPainter(
              animation.value,
              circleColor: ColorPalette.kPrimary,
              navigationBarColor: Colors.white,
              selectedIndex: _selectedTabIndex,
            ),
            size: Size(
              MediaQuery.of(context).size.width - (2 * horizontalMargin),
              120.0,
            ),
            child: SizedBox(
              height: 120.0,
              width: MediaQuery.of(context).size.width - (2 * horizontalMargin),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_navItems.length, (index) {
                    final item = _navItems[index];
                    final isSelected = index == _selectedTabIndex;
                    return _buildNavItem(item, index, isSelected);
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, int index, bool isSelected) {
    final double itemWidth =
        (MediaQuery.of(context).size.width -
            (2 * horizontalMargin) -
            (2 * horizontalPadding)) /
        _navItems.length;

    return GestureDetector(
      onTap: () => _switchToTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 375),
        curve: Curves.easeOut,
        height: 105,
        width: itemWidth,
        padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
        alignment: isSelected ? Alignment.topCenter : Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 375),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: SvgPicture.asset(
                    isSelected ? item.activeIconPath : item.iconPath,
                    key: ValueKey(
                      '${isSelected ? 'selected' : 'normal'}${item.iconPath}',
                    ),
                    height: 28.0,
                    width: 28.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (!isSelected) ...[
              const SizedBox(height: 5),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.kPrimary.withOpacity(0.7),
                ),
              ),
            ],
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
      _animateDrop(index);
    }
  }
}

/// Navigation item model
class _NavItem {
  final String iconPath;
  final String activeIconPath;
  final String label;

  const _NavItem({
    required this.iconPath,
    required this.activeIconPath,
    required this.label,
  });
}
