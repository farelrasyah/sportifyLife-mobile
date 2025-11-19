/// Model for onboarding page data
class OnboardingPageModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  /// List of all onboarding pages
  static List<OnboardingPageModel> get pages => [
    const OnboardingPageModel(
      title: 'Track Your Goal',
      description:
          'Don\'t worry if you have trouble determining your goals, We can help you determine your goals and track your goals',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingPageModel(
      title: 'Get Burn',
      description:
          'Let\'s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingPageModel(
      title: 'Eat Well',
      description:
          'Let\'s start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun',
      imagePath: 'assets/images/onboarding_3.png',
    ),
    const OnboardingPageModel(
      title: 'Improve Sleep Quality',
      description:
          'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
      imagePath: 'assets/images/onboarding_4.png',
    ),
  ];
}
