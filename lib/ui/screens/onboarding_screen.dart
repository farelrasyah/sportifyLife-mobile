import 'package:flutter/material.dart';
import '../../data/models/onboarding_page_model.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../widgets/page_indicator.dart';
import '../../app/routes.dart';

/// Onboarding screen with 4 pages showcasing app features
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPageModel> _pages = OnboardingPageModel.pages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.kBackground,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: Spacing.screenAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _pages.length,
                  ),
                  _buildNextButton(),
                ],
              ),
            ),
          ),
          Spacing.verticalMD,
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPageModel page) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            child: Image.asset(page.imagePath, fit: BoxFit.cover),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.verticalXL,
                Text(page.title, style: AppTypography.onboardingTitle),
                Spacing.verticalMD,
                Text(
                  page.description,
                  style: AppTypography.onboardingDescription,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: ColorPalette.kOnboardingButton,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.kOnboardingButton.withOpacity(0.3),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: ColorPalette.kOnboardingButtonIcon,
          size: 20.0,
        ),
      ),
    );
  }
}
