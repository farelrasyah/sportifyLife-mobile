import 'package:flutter/material.dart';

class OnboardingPageData {
  final String assetPath;
  final String assetType; // 'gif', 'lottie', or 'rive'
  final String title;
  final String description;
  final Color backgroundColor;
  final String buttonText;

  OnboardingPageData({
    required this.assetPath,
    required this.assetType,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.buttonText,
  });
}

final List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    assetPath: 'assets/images/onboarding_1.riv',
    assetType: 'rive', // Fixed: Use 'rive' for .riv files
    title: 'Learn Smarter, Not Harder',
    description:
        'Access interactive lessons, bite-sized tips, and engaging visuals that make learning feel effortless.',
    backgroundColor: Color(0xFFE1F5FE), // Slide 1 - lightest blue
    buttonText: 'Next',
  ),
  OnboardingPageData(
    assetPath: 'assets/images/onboarding_2.json',
    assetType: 'lottie',
    title: 'Your Study Buddy',
    description:
        'Stay organized, track progress, and keep all your learning tools in one place.',
    backgroundColor: Color(0xFFB3E5FC), // Slide 2 - medium blue
    buttonText: 'Next',
  ),
  OnboardingPageData(
    assetPath: 'assets/images/onboarding_3.json',
    assetType: 'lottie',
    title: 'Connect & Collaborate',
    description:
        'Join a community of learners, share ideas, and grow together.',
    backgroundColor: Color(0xFF81D4FA), // Slide 3 - deepest blue
    buttonText: 'Get Started',
  ),
];
